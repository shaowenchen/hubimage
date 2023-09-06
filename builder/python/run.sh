#!/bin/sh

for line in $(cat tag)
do
    echo $line
    docker buildx build --push --platform=linux/arm,linux/arm64,linux/amd64 -t hubimage/builder-python:$line - << EOF
FROM hubimage/runtime-python:$line
RUN mkdir -p /builder && \
    pip config --user set global.index https://mirrors.aliyun.com/pypi/simple/ && \
    pip config --user set global.index-url https://mirrors.aliyun.com/pypi/simple/ && \
    pip config --user set global.trusted-host mirrors.aliyun.com
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ninja-build && \
    build-essential && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /builder
EOF
done
