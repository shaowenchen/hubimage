#!/bin/bash
IMAGES_LIST_FILE=$1

ALL_IMAGES="$(cat $1 | sed '/#/d' | sed 's/: /,/g')"

function tag_exists() {
    if skopeo inspect docker://$1:$2 >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

for image in ${ALL_IMAGES}; do
    IFS=', ' read -r -a imagearr <<<"$image"

    src_tags=$(skopeo list-tags docker://${imagearr[0]} | jq '.Tags[]' | sed '1!G;h;$!d')
    dest_tags=$(skopeo list-tags docker://${imagearr[1]} | jq '.Tags[]' | sed '1!G;h;$!d')

    # Counter for copied tags per image
    tag_count=0

    for tag in $src_tags; do
        # Break if we've already copied 10 tags for this image
        if [ $tag_count -ge 5 ]; then
            echo "Copied 5 tags for ${imagearr[0]}, moving to next image"
            break
        fi

        tag=$(echo $tag | sed 's/"//g')
        if [[ ${#tag} -gt 30 || ${tag} == *"--"* || ${tag} =~ ([0-9]{8}) || ${tag} =~ -[a-f0-9]{7,}- || ${tag} =~ -SNAPSHOT$ || ${tag} =~ beta[0-9]+ || ${tag} == *"windows"* || ${tag} == *"0.0.0"* || ${tag} == *"dev"* || ${tag} == sha256* || ${tag} == sha-* || ${tag} == *.sig || ${tag} == *post1 || ${tag} == *post2 || ${tag} =~ [0-9]{4}-[0-9]{2}-[0-9]{2} ]]; then
            # echo "Skipping special tag ${imagearr[0]}:${tag}"
            continue
        fi

        if echo "$dest_tags" | grep -q "\"$tag\""; then
            # echo "Skipping copy existed tag ${imagearr[1]}:${tag}"
            continue
        elif tag_exists ${imagearr[1]} ${tag} && [[ ! ${tag} == *"latest"* ]] && [ ${tag} != "master" ] && [ ${tag} != "main" ] && [ ${tag} != "dev" ] && [ ${tag} != "development" ] && [ ${tag} != "nightly" ] && [ ${tag} != "test" ] && [ ${tag} != "testing" ] && [ ${tag} != "staging" ] && [ ${tag} != "experimental" ] && [ ${tag} != "alpha" ] && [ ${tag} != "beta" ]; then
            # echo "Skipping copy ${imagearr[0]}:${tag} as it already exists in ${imagearr[1]}:${tag}"
            continue
        else
            echo "Copying ${imagearr[0]}:${tag} to ${imagearr[1]}:${tag}"
            docker run --rm -v ~/.docker/config.json:/auth.json quay.io/skopeo/stable copy --multi-arch all docker://${imagearr[0]}:${tag} docker://${imagearr[1]}:${tag} --dest-authfile /auth.json --insecure-policy --src-tls-verify=false --dest-tls-verify=false --retry-times 5 --format v2s2 
            if [ $? -ne 0 ]; then
                echo "Failed to copy ${imagearr[0]}:${tag} to ${imagearr[1]}:${tag}"
                break 2
            fi
            # Increment the tag counter after successful copy
            ((tag_count++))
        fi
    done
done
