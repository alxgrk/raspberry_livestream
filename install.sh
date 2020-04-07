#!/bin/bash

set -x

OPENRESTY_PATH=/usr/local/openresty

while getopts ":d:" opt; do
  case $opt in
    d) DOMAIN="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [[ -z $DOMAIN ]]; then
	echo "Please set '-d' for the Pi's domain name."
	exit 1
fi

function resolveDomain() {
	for f in $1 
	do 
		cat $f | sed "s/+++DOMAIN+++/$DOMAIN/g" | sudo tee $2/${f##*/} > /dev/null
	done
}
resolveDomain nginx.conf $OPENRESTY_PATH/nginx/conf/
resolveDomain "frontend/*" $OPENRESTY_PATH/nginx/


# certbot conf
if [[ ! -e $OPENRESTY_PATH/certbot/.certbot-ran ]]
then
	sudo mkdir -p $OPENRESTY_PATH/certbot/conf
	curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf | sudo tee $OPENRESTY_PATH/certbot/conf/options-ssl-nginx.conf > /dev/null
	curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem | sudo tee $OPENRESTY_PATH/certbot/conf/ssl-dhparams.pem > /dev/null

	# Creating dummy certificate for your domain ...
	CERT_PATH="/etc/letsencrypt/live/$DOMAIN"
	sudo mkdir -p $CERT_PATH
	sudo openssl req -x509 -nodes -newkey rsa:4096 -days 1\
		-keyout "$CERT_PATH/privkey.pem" \
		-out "$CERT_PATH/fullchain.pem" \
		-subj "/CN=localhost"
fi
