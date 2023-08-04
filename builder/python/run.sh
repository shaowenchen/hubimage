#!/bin/sh

for line in $(cat tag)
do
    echo $line
    docker build -t hubimage/builder-python:$line  - << EOF
FROM python:$line
RUN pip config --user set global.index https://mirrors.aliyun.com/pypi/simple/ && \
    pip config --user set global.index-url https://mirrors.aliyun.com/pypi/simple/ && \
    pip config --user set global.trusted-host mirrors.aliyun.com && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
    echo "Asia/Shanghai" > /etc/timezone;
EOF

    docker push hubimage/builder-python:$line
done
