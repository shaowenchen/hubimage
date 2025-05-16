#!/bin/bash

# Script to traverse all directories and fix the format of image mappings in images.yaml and images-acr.yaml

# Find all directories in the project
DIRECTORIES=$(find . -type d)

if [ -z "$DIRECTORIES" ]; then
    echo "No directories found in the project."
    exit 1
fi

for DIR in $DIRECTORIES; do
    echo "Processing directory: $DIR"

    # Check for images.yaml
    FILE1="$DIR/images.yaml"
    FILE2="$DIR/images-acr.yaml"

    for FILE in "$FILE1" "$FILE2"; do
        if [ -f "$FILE" ]; then
            echo "Checking format in $FILE..."

            # Temporary file to store updated content
            TEMP_FILE="${FILE}.tmp"
            > "$TEMP_FILE"

            mismatch_found=0

            # Read the file line by line
            while IFS=':' read -r original replacement; do
                # Preserve empty lines and comments
                if [[ -z "$original" || "$original" =~ ^[[:space:]]*# || "$original" =~ ^[[:space:]]*$ ]]; then
                    echo "$original$replacement" >> "$TEMP_FILE"
                    continue
                fi

                # Extract the domain from the original image path
                domain=$(echo "$original" | cut -d'/' -f1 | tr -d ' ')
                # Convert dots to hyphens in domain
                domain_converted=$(echo "$domain" | tr '.' '-')
                # Extract the path after the domain
                path=$(echo "$original" | cut -d'/' -f2- | tr -d ' ')
                # Convert underscores and slashes to hyphens in path
                path_converted=$(echo "$path" | tr '_/' '-')
                # Clean up replacement by removing leading/trailing spaces
                replacement=$(echo "$replacement" | tr -d ' ')

                # Determine the prefix used in the replacement
                if [[ "$replacement" == *"registry.cn-beijing.aliyuncs.com/opshub/"* ]]; then
                    prefix="registry.cn-beijing.aliyuncs.com/opshub"
                    expected_replacement="registry.cn-beijing.aliyuncs.com/opshub/${domain_converted}-${path_converted}"
                elif [[ "$replacement" == *"hubimage/"* ]]; then
                    prefix="hubimage"
                    expected_replacement="hubimage/${domain_converted}-${path_converted}"
                else
                    # Default to the first prefix if neither is found
                    prefix="registry.cn-beijing.aliyuncs.com/opshub"
                    expected_replacement="registry.cn-beijing.aliyuncs.com/opshub/${domain_converted}-${path_converted}"
                fi

                # Check if the replacement matches the expected format
                if [[ "$replacement" != "$expected_replacement" ]]; then
                    echo "Format mismatch for: $original"
                    echo "Expected: $expected_replacement"
                    echo "Found: $replacement"
                    echo "Fixing format..."
                    echo "---"
                    mismatch_found=1
                    # Write the corrected format to the temp file
                    echo "$original: $expected_replacement" >> "$TEMP_FILE"
                else
                    # Write the original line as is
                    echo "$original: $replacement" >> "$TEMP_FILE"
                fi
            done < "$FILE"

            # If mismatches were found, update the original file
            if [[ $mismatch_found -eq 1 ]]; then
                mv "$TEMP_FILE" "$FILE"
                echo "Updated $FILE with corrected formats."
            else
                rm "$TEMP_FILE"
                echo "No mismatches found in $FILE."
            fi

            echo "Check and fix completed for $FILE."
        else
            echo "$FILE not found, skipping."
        fi
    done
done 