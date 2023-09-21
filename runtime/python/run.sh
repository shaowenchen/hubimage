#!/bin/sh

for line in $(cat tag)
do
    echo $line
    docker buildx build --push --platform=linux/arm,linux/arm64,linux/amd64 -t hubimage/runtime-python:$line - << EOF
FROM python:$line
LABEL maintainer="shaowenchen <mail@chenshaowen.com>"
RUN mkdir -p /runtime && \
    pip install --upgrade pip && \
    pip config --user set global.index https://mirrors.aliyun.com/pypi/simple/ && \
    pip config --user set global.index-url https://mirrors.aliyun.com/pypi/simple/ && \
    pip config --user set global.trusted-host mirrors.aliyun.com && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone
WORKDIR /runtime
EOF
done
