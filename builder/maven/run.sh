#!/bin/sh

for line in $(cat tag)
do
    echo $line
    docker build -t hubimage/runtime-maven:$line - << EOF
FROM hubimage/runtime-openjdk:$line as builder
ADD https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.9.4/apache-maven-3.9.4-bin.tar.gz /temp/apache-maven-3.9.4-bin.tar.gz
RUN cd /temp/ && tar -zxvf apache-maven-3.9.4-bin.tar.gz

FROM hubimage/runtime-openjdk:$line
RUN mkdir -p /usr/local/maven/repository
COPY --from=builder /temp/apache-maven-3.9.4 /usr/local/maven/apache-maven-3.9.4
ADD https://raw.githubusercontent.com/shaowenchen/hubimage/master/builder/maven/settings.xml /usr/local/maven/apache-maven-3.9.4/conf/
ENV MAVEN_HOME /usr/local/maven/apache-maven-3.9.4
ENV CLASSPATH ${MAVEN_HOME}/lib:$CLASSPATH
ENV PATH ${MAVEN_HOME}/bin:$PATH
EOF
    docker push hubimage/runtime-maven:$line
done