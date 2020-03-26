#!/bin/bash

set -x

sudo /usr/local/nginx/sbin/nginx -s stop
sudo /usr/local/nginx/sbin/nginx

sleep 2

./stream.sh
