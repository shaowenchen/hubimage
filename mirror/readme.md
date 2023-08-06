## CentOS

```bash
curl -sfL https://raw.githubusercontent.com/shaowenchen/hubimage/main/mirror/centos/get.sh | VERSION=7 sh -
```

version: 6, 7, 8

## Debian

```bash
curl -sfL https://raw.githubusercontent.com/shaowenchen/hubimage/main/mirror/debian/get.sh | VERSION=8 sh -
```

version: 7, 8, 9, 10, 11

## Ubuntu

```bash
curl -sfL https://raw.githubusercontent.com/shaowenchen/hubimage/main/mirror/ubuntu/get.sh | VERSION=16.04 sh -
```

version: 14.04, 16.04, 18.04, 20.04

## Alpine

```bash
sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
```
