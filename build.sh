#!/bin/bash

set -x

mkdir build
cd build

# get rtmp module
git clone git://github.com/arut/nginx-rtmp-module.git

# build nginx
OPENRESTY_VERSION=openresty-1.15.8.3
if [ ! -d $OPENRESTY_VERSION ]; then
	curl https://openresty.org/download/$OPENRESTY_VERSION.tar.gz -o $OPENRESTY_VERSION.tar.gz
	tar xzf $OPENRESTY_VERSION.tar.gz
fi
cd $OPENRESTY_VERSION

./configure -j2 --with-pcre-jit --with-ipv6 --with-http_ssl_module --add-module=../nginx-rtmp-module --with-cc-opt="-Wimplicit-fallthrough=0"
make -j2
sudo make install

