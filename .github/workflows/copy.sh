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
    for tag in $(skopeo list-tags docker://${imagearr[0]} | jq '.Tags[]' | sed '1!G;h;$!d'); do
        tag=$(echo $tag | sed 's/"//g')
        if [[ ${#tag} -gt 30 || ${tag} == *"--"* || ${tag} =~ ([0-9]{8}) || ${tag} =~ -[a-f0-9]{7,}- || ${tag} =~ -SNAPSHOT$ || ${tag} =~ beta[0-9]+ || ${tag} == *"windows"* || ${tag} == *"0.0.0"* || ${tag} == *"dev"* || ${tag} == sha256* || ${tag} == *.sig || ${tag} == *post1 || ${tag} == *post2 ]]; then
            echo "Skipping special tag ${imagearr[0]}:${tag}"
            continue
        fi

        if tag_exists ${imagearr[1]} ${tag} && [ ${tag} != "latest" ] && [ ${tag} != "master" ] && [ ${tag} != "main" ] && [ ${tag} != "dev" ] && [ ${tag} != "development" ] && [ ${tag} != "nightly" ] && [ ${tag} != "test" ] && [ ${tag} != "testing" ] && [ ${tag} != "staging" ] && [ ${tag} != "experimental" ] && [ ${tag} != "alpha" ] && [ ${tag} != "beta" ]; then
            echo "Skipping copy ${imagearr[0]}:${tag} as it already exists in ${imagearr[1]}:${tag}"
        else
            echo "Copying ${imagearr[0]}:${tag} to ${imagearr[1]}:${tag}"
            docker run --rm -v ~/.docker/config.json:/auth.json quay.io/skopeo/stable copy --multi-arch all docker://${imagearr[0]}:${tag} docker://${imagearr[1]}:${tag} --dest-authfile /auth.json --insecure-policy --src-tls-verify=false --dest-tls-verify=false --retry-times 5
            if [ $? -ne 0 ]; then
                echo "Failed to copy ${imagearr[0]}:${tag} to ${imagearr[1]}:${tag}"
                break 2
            fi
        fi
    done
done
