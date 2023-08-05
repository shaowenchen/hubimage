#!/bin/bash

if [ "x${VERSION}" = "x" ]; then
  VERSION=$(cat /etc/os-release | grep "VERSION_ID" | cut -d '"' -f 2)
fi

repo_url="https://raw.githubusercontent.com/shaowenchen/hubimage/master/mirror/debian/"

case $VERSION in
  7)
    repo_url=$repo_url"7.wheezy.aliyun.sources.list"
    ;;
  8)
    repo_url=$repo_url"8.jessie.aliyun.sources.list"
    ;;
  9)
    repo_url=$repo_url"9.stretch.aliyun.sources.list"
    ;;
  10)
    repo_url=$repo_url"10.buster.aliyun.sources.list"
    ;;
  11)
    repo_url=$repo_url"11.bullseye.aliyun.sources.list"
    ;;
  *)
    echo "Unsupported version"
    exit 1
    ;;
esac

mv /etc/apt/sources.list /etc/apt/sources.list.backup.$(date +"%Y%m%d%H%M%S") || true
curl -sfL $repo_url -o /etc/apt/sources.list

apt update
