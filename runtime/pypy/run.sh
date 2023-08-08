#!/bin/sh

for line in $(cat tag)
do
    echo $line
    docker buildx build --push --platform=linux/arm,linux/arm64,linux/amd64 -t hubimage/runtime-pypy:$line - << EOF
FROM pypy:$line
LABEL maintainer="shaowenchen <mail@chenshaowen.com>"
RUN mkdir -p /runtime && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone
WORKDIR /runtime
EOF
done
