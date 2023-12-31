#!/bin/sh

docker buildx build --push --platform=linux/arm,linux/arm64,linux/amd64 -t hubimage/runtime-ubuntu:18.04 - << EOF
FROM ubuntu:18.04
LABEL maintainer="shaowenchen <mail@chenshaowen.com>"
RUN mkdir -p /runtime && \
    apt-get -y update && \
    apt-get -y install vim tzdata wget curl xz-utils bash gettext ca-certificates && \
    wget https://raw.githubusercontent.com/shaowenchen/hubimage/main/mirror/ubuntu/18.04.bionic.aliyun.sources.list -O /etc/apt/sources.list && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apt-get clean && \
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*
WORKDIR /runtime
EOF
