#!/bin/bash

HTPASSWD_FILE=/usr/local/openresty/conf/.htpasswd
sudo mkdir -p /usr/local/openresty/conf

for user in "$@"
do
    echo "Please enter your password for user '$user'"

    [[ ! -f $HTPASSWD_FILE ]] && create='-c' # add -c option, if file does not exist yet
    
    sudo htpasswd ${create} $HTPASSWD_FILE $user
done
