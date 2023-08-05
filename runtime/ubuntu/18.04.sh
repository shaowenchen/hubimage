#!/bin/sh

docker build -t hubimage/runtime-ubuntu:18.04 - << EOF
FROM ubuntu:18.04
LABEL maintainer="shaowenchen <mail@chenshaowen.com>"
RUN set -eux && \
    apt-get -y update && \
    apt-get -y install wget xz-utils bash tzdata gettext ca-certificates && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apt-get clean && \
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*
EOF
docker push hubimage/runtime-ubuntu:18.04
