#!/bin/sh
for line in $(cat tag)
do
    echo $line
    docker build -t hubimage/runtime-node:$line - << EOF
FROM node:$line
LABEL maintainer="shaowenchen <mail@chenshaowen.com>"
RUN mkdir -p /runtime && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone
WORKDIR /runtime
EOF
    docker push hubimage/runtime-node:$line
done
