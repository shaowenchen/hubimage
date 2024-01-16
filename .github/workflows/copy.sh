#!/bin/bash
IMAGES_LIST_FILE=$1

ALL_IMAGES="$(cat $1 | sed '/#/d' | sed 's/: /,/g' )"
TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "${DOCKERHUB_USERNAME}", "password": "${DOCKERHUB_PASSWORD}"}' https://hub.docker.com/v2/users/login/ | jq -r .token)

function docker_tag_exists() {
    curl --silent -f --head -lL https://hub.docker.com/v2/repositories/$1/tags/$2/ > /dev/null
}

for image in ${ALL_IMAGES}; do
    IFS=', ' read -r -a imagearr <<< "$image"
    for tag in $(skopeo list-tags docker://${imagearr[0]} | jq '.Tags[]' | sed '1!G;h;$!d' ); do
        tag=$(echo $tag | sed 's/"//g')
        if [ ${#tag} -gt 28 ]
        then
            echo "Skipping too long tag ${imagearr[0]}:${tag}"
            continue
        fi

        if docker_tag_exists ${imagearr[1]} ${tag} && [ ${tag} != "latest" ] && [ ${tag} != "master" ] && [ ${tag} != "main" ] && [ ${tag} != "dev" ] && [ ${tag} != "development" ] && [ ${tag} != "nightly" ] && [ ${tag} != "test" ] && [ ${tag} != "testing" ] && [ ${tag} != "staging" ] && [ ${tag} != "experimental" ] && [ ${tag} != "alpha" ] && [ ${tag} != "beta" ] ;
        then
            echo "Skipping Copying ${imagearr[0]}:${tag} as it already exists in ${imagearr[1]}:${tag}"
        else
            echo "Copying ${imagearr[0]}:${tag} to ${imagearr[1]}:${tag}"
            docker run --rm -v ~/.docker/config.json:/auth.json quay.io/skopeo/stable copy docker://${imagearr[0]}:${tag} docker://${imagearr[1]}:${tag} --dest-authfile /auth.json --insecure-policy --src-tls-verify=false --dest-tls-verify=false --retry-times 5 --all
        fi
    done
done
