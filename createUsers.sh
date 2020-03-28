#!/bin/bash

HTPASSWD_FILE=/usr/local/nginx/conf/.htpasswd

for user in "$@"
do
    echo "Please enter your password for user '$user'"

    [[ ! -f $HTPASSWD_FILE ]] && create='-c' # add -c option, if file does not exist yet
    
    sudo htpasswd ${create} $HTPASSWD_FILE $user
done
