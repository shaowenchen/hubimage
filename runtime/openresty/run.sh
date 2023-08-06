#!/bin/sh

for line in $(cat tag)
do
    echo $line
    docker buildx build --load --push --platform=linux/arm,linux/arm64,linux/amd64 -t hubimage/runtime-openresty:$line - << EOF
FROM openresty/openresty:$line
LABEL maintainer="shaowenchen <mail@chenshaowen.com>"
RUN mkdir -p /runtime && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone
WORKDIR /runtime
EOF
done