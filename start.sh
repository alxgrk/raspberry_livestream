#!/bin/bash

set -x

OPENRESTY_PATH=/usr/local/openresty

while getopts ":d:m:" opt; do
  case $opt in
    d) DOMAIN="$OPTARG"
    ;;
    m) MAIL="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

stop_nginx() {
    printf "\rEnsuring nginx is stopped..."
    sudo $OPENRESTY_PATH/bin/openresty -s stop
}

trap 'stop_nginx' SIGINT

stop_nginx
sudo $OPENRESTY_PATH/bin/openresty

sleep 2

# setup ssl
CERTBOT_PATH=$OPENRESTY_PATH/certbot
if [[ ! -e $CERTBOT_PATH/.certbot-ran ]]
then
	if [[ -z $DOMAIN || -z $MAIL ]]; then
		echo "Please set '-d' for the Pi's domain name and '-m' for you mail address needed for Let's Encrypt."
		exit 1
	fi

	sudo rm -rf /etc/letsencrypt/{live,renewal}/$DOMAIN*
	sudo rm -rf /etc/letsencrypt/archive/$DOMAIN/
	sudo certbot certonly --webroot -n -w $CERTBOT_PATH -d $DOMAIN -m $MAIL --rsa-key-size 4096 --agree-tos --force-renewal
	sudo touch $CERTBOT_PATH/.certbot-ran
fi

./stream.sh
