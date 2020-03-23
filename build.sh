#!/bin/bash

set -x

mkdir build
cd build

# get rtmp module
git clone git://github.com/arut/nginx-rtmp-module.git

# build nginx
NGINX_VERSION=nginx-1.14.2
if [ ! -d $NGINX_VERSION ]; then
	curl http://nginx.org/download/$NGINX_VERSION.tar.gz -o $NGINX_VERSION.tar.gz
	tar xzf $NGINX_VERSION.tar.gz
fi
cd $NGINX_VERSION

./configure --with-http_ssl_module --add-module=../nginx-rtmp-module --with-cc-opt="-Wimplicit-fallthrough=0"
make
sudo make install
