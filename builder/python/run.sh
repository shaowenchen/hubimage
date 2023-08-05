#!/bin/sh

for line in $(cat tag)
do
    echo $line
    docker build -t hubimage/builder-python:$line - << EOF
FROM hubimage/runtime-python:$line
RUN pip config --user set global.index https://mirrors.aliyun.com/pypi/simple/ && \
    pip config --user set global.index-url https://mirrors.aliyun.com/pypi/simple/ && \
    pip config --user set global.trusted-host mirrors.aliyun.com
EOF

    docker push hubimage/builder-python:$line
done
