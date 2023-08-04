#!/bin/sh

for line in $(cat tag)
do
    echo $line
    docker build -t hubimage/builder-golang:$line  - << EOF
FROM golang:$line
RUN go env -w GO111MODULE=on && \
    go env -w GOSUMDB=on && \
    go env -w GOPROXY=https://mirrors.aliyun.com/goproxy/,direct
EOF

    docker push hubimage/builder-golang:$line
done