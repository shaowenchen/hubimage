## Quick Start

```bash
curl -sfL https://raw.githubusercontent.com/shaowenchen/hubimage/main/mirror/get.sh | sh -
```

Automatically detect the system version and install the corresponding mirror.

## CentOS

```bash
curl -sfL https://raw.githubusercontent.com/shaowenchen/hubimage/main/mirror/centos/get.sh | VERSION=7 sh -
```

version: 6, 7, 8

Or let the script detect the version:

```bash
curl -sfL https://raw.githubusercontent.com/shaowenchen/hubimage/main/mirror/centos/get.sh | sh -
```

## Debian

```bash
curl -sfL https://raw.githubusercontent.com/shaowenchen/hubimage/main/mirror/debian/get.sh | VERSION=8 sh -
```

version: 7, 8, 9, 10, 11

Or let the script detect the version:

```bash
curl -sfL https://raw.githubusercontent.com/shaowenchen/hubimage/main/mirror/debian/get.sh | sh -
```

## Ubuntu

```bash
curl -sfL https://raw.githubusercontent.com/shaowenchen/hubimage/main/mirror/ubuntu/get.sh | VERSION=22.04 sh -
```

version: 14.04, 16.04, 18.04, 20.04, 22.04

Or let the script detect the version:

```bash
curl -sfL https://raw.githubusercontent.com/shaowenchen/hubimage/main/mirror/ubuntu/get.sh | sh -
```

## Alpine

```bash
sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
```
