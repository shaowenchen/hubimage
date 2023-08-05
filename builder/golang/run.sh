#!/bin/sh

for line in $(cat tag)
do
    echo $line
    docker build -t hubimage/builder-golang:$line - << EOF
FROM golang:$line
LABEL maintainer="shaowenchen <mail@chenshaowen.com>"
RUN mkdir -p /builder && \
    go env -w GO111MODULE=on && \
    go env -w GOSUMDB=on && \
    go env -w GOPROXY=https://mirrors.aliyun.com/goproxy,direct
WORKDIR /builder
EOF

    docker push hubimage/builder-golang:$line
done