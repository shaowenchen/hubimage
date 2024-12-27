#!/bin/bash

if [ "x${VERSION}" = "x" ]; then
  VERSION=$(cat /etc/os-release | grep "VERSION_ID" | cut -d '"' -f 2)
fi

default_proxy="https://cf.ghproxy.cc/"
proxy=${PROXY:-$default_proxy}
repo_url="$proxy""https://raw.githubusercontent.com/shaowenchen/hubimage/main/mirror/centos/"

case $VERSION in
6)
  repo_url=$repo_url"6.aliyun.repo"
  ;;
7)
  repo_url=$repo_url"7.aliyun.repo"
  ;;
8)
  repo_url=$repo_url"8.aliyun.repo"
  ;;
*)
  echo "Unsupported version"
  exit 1
  ;;
esac

mv /etc/yum.repos.d /etc/yum.repos.d.backup.$(date +"%Y%m%d%H%M%S") || true
mkdir /etc/yum.repos.d
curl -sfL $repo_url -o /etc/yum.repos.d/CentOS-Base.repo

yum clean all
yum makecache
