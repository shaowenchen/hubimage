#!/bin/bash

if [ "x${VERSION}" = "x" ]; then
  VERSION=$(cat /etc/os-release | grep "VERSION_ID" | cut -d '"' -f 2)
fi

repo_url="https://raw.githubusercontent.com/shaowenchen/hubimage/main/mirror/ubuntu/"

case $VERSION in
  14.04)
    repo_url=$repo_url"14.04.trusty.aliyun.sources.list"
    ;;
  16.04)
    repo_url=$repo_url"16.04.xenial.aliyun.sources.list"
    ;;
  18.04)
    repo_url=$repo_url"18.04.bionic.aliyun.source.list"
    ;;
  20.04)
    repo_url=$repo_url"20.04.focal.aliyun.sources.list"
    ;;
  22.04)
    repo_url=$repo_url"22.04.jammy.aliyun.sources.list"
    ;;
  *)
    echo "Unsupported version"
    exit 1
    ;;
esac

if [ -e "/etc/apt/sources.list" ]; then
    mv /etc/apt/sources.list /etc/apt/sources.list.backup.$(date +"%Y%m%d%H%M%S")
else
    echo "File not found: /etc/apt/sources.list"
fi

curl -sfL $repo_url -o /etc/apt/sources.list

apt update