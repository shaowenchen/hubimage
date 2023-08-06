#!/bin/sh

for line in $(cat tag)
do
    echo $line
    docker buildx build --push --platform=linux/arm -t hubimage/runtime-openresty:$line - << EOF
FROM openresty/openresty:$line
LABEL maintainer="shaowenchen <mail@chenshaowen.com>"
RUN mkdir -p /runtime && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone
WORKDIR /runtime
EOF

    echo $line
    docker buildx build --push --platform=linux/arm64 -t hubimage/runtime-openresty:$line - << EOF
FROM openresty/openresty:$line
LABEL maintainer="shaowenchen <mail@chenshaowen.com>"
RUN mkdir -p /runtime && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone
WORKDIR /runtime
EOF

    echo $line
    docker buildx build --push --platform=linux/amd64 -t hubimage/runtime-openresty:$line - << EOF
FROM openresty/openresty:$line
LABEL maintainer="shaowenchen <mail@chenshaowen.com>"
RUN mkdir -p /runtime && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone
WORKDIR /runtime
EOF
done
