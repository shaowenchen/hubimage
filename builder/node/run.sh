#!/bin/sh

for line in $(cat tag)
do
    echo $line
    docker build -t hubimage/builder-node:$line - << EOF
FROM hubimage/runtime-node:$line
RUN npm config set registry http://registry.npm.taobao.org/ && \
    npm config set sass_binary_site http://cdn.npm.taobao.org/dist/node-sass && \
    npm config set phantomjs_cdnurl https://cdn.npm.taobao.org/dist/phantomjs/ && \
    npm config set chromedriver_cdnurl https://cdn.npm.taobao.org/dist/chromedriver && \
    npm config set operadriver_cdnurl https://cdn.npm.taobao.org/dist/operadriver && \
    npm config set fse_binary_host_mirror https://cdn.npm.taobao.org/dist/fsevents && \
    npm config set prefer-offline true || true

RUN yarn config set registry http://registry.npm.taobao.org/ && \
    yarn config set sass_binary_site http://cdn.npm.taobao.org/dist/node-sass && \
    yarn config set phantomjs_cdnurl https://cdn.npm.taobao.org/dist/phantomjs/ && \
    yarn config set chromedriver_cdnurl https://cdn.npm.taobao.org/dist/chromedriver && \
    yarn config set operadriver_cdnurl https://cdn.npm.taobao.org/dist/operadriver && \
    yarn config set fse_binary_host_mirror https://cdn.npm.taobao.org/dist/fsevents && \
    yarn config set install.prefer-offline true || true
EOF
    docker push hubimage/builder-node:$line
done
