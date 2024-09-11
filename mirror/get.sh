#!/bin/bash

os=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')

default_proxy="https://ghp.ci/"
proxy=${PROXY:-$default_proxy}

case "$os" in
"CentOS Linux")
    echo "Detected CentOS"
    curl -sfL "$proxy"https://raw.githubusercontent.com/shaowenchen/hubimage/main/mirror/centos/get.sh | sh -
    ;;
"Debian GNU/Linux")
    echo "Detected Debian"
    curl -sfL "$proxy"https://raw.githubusercontent.com/shaowenchen/hubimage/main/mirror/debian/get.sh | sh -
    ;;
"Ubuntu")
    echo "Detected Ubuntu"
    curl -sfL "$proxy"https://raw.githubusercontent.com/shaowenchen/hubimage/main/mirror/ubuntu/get.sh | sh -
    ;;
"Alpine Linux")
    echo "Detected Alpine"
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
    ;;
*)
    echo "Unsupported operating system: $os"
    exit 1
    ;;
esac
