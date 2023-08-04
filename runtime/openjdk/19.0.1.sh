#!/bin/sh

JDK_VERSION=19.0.1
JDK_URL=https://download.java.net/java/GA/jdk19.0.1/afdd2e245b014143b62ccb916125e3ce/10/GPL/openjdk-19.0.1_linux-x64_bin.tar.gz

docker build -t hubimage/runtime-openjdk:$JDK_VERSION  - << EOF
FROM hubimage/runtime-ubuntu:22.04 as builder
ADD $JDK_URL /temp/openjdk.tar.gz
RUN tar -zxf /temp/openjdk.tar.gz -C /temp

FROM hubimage/runtime-ubuntu:22.04
COPY --from=builder /temp/jdk-$JDK_VERSION /usr/local/
ENV JAVA_HOME /usr/local/jdk-$JDK_VERSION
ENV PATH $JAVA_HOME/bin:$PATH
ENV LANG C.UTF-8
ENV JAVA_VERSION $JDK_VERSION
EOF

docker push hubimage/runtime-openjdk:$JDK_VERSION