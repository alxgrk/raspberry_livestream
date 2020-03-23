#!/bin/bash

set -x

./stream.sh &
sudo /usr/local/nginx/sbin/nginx -s stop
sudo /usr/local/nginx/sbin/nginx

