#!/bin/sh

docker buildx build --push --platform=linux/arm,linux/arm64,linux/amd64 -t hubimage/runtime-ubuntu:20.04 - << EOF
FROM ubuntu:20.04
LABEL maintainer="shaowenchen <mail@chenshaowen.com>"
RUN mkdir -p /runtime && \
    apt-get -y update && \
    apt-get -y install wget curl xz-utils bash gettext ca-certificates && \
    wget https://raw.githubusercontent.com/shaowenchen/hubimage/master/mirror/ubuntu/20.04.focal.aliyun.source.list -O /etc/apt/sources.list && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apt-get clean && \
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*
WORKDIR /runtime
EOF
