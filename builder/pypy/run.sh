#!/bin/sh

for line in $(cat tag)
do
    echo $line
    docker buildx build --push --platform=linux/arm,linux/arm64,linux/amd64 -t hubimage/builder-pypy:$line - << EOF
FROM hubimage/runtime-pypy:$line
RUN mkdir -p /builder && \
    pip config --user set global.index https://mirrors.aliyun.com/pypi/simple/ && \
    pip config --user set global.index-url https://mirrors.aliyun.com/pypi/simple/ && \
    pip config --user set global.trusted-host mirrors.aliyun.com
WORKDIR /builder
EOF
done
