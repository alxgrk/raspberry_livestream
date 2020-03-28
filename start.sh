#!/bin/bash

set -x

stop_nginx() {
    printf "\rEnsuring nginx is stopped..."
    sudo /usr/local/openresty/bin/openresty -s stop
}

trap 'stop_nginx' SIGINT

stop_nginx
sudo /usr/local/openresty/bin/openresty

sleep 2

./stream.sh
