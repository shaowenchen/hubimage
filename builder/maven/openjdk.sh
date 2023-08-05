#!/bin/sh

for line in $(cat tag)
do
    echo $line
    docker build -t hubimage/builder-maven:3-openjdk$line - << EOF
FROM maven:3.8-openjdk-$line
LABEL maintainer="shaowenchen <mail@chenshaowen.com>"
RUN mkdir -p /builder
WORKDIR /builder
ADD https://raw.githubusercontent.com/shaowenchen/hubimage/master/builder/maven/settings.xml /usr/share/maven/conf
EOF
    docker push hubimage/builder-maven:3-openjdk$line
done