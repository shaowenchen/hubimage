#!/bin/sh

for line in $(cat tag)
do
    echo $line
    docker buildx build --push --platform=linux/arm64,linux/amd64 -t hubimage/builder-pypy:$line - << EOF
FROM hubimage/runtime-pypy:$line
RUN mkdir -p /builder
WORKDIR /builder
EOF
done
