#!/bin/bash

#set -x

declare -A ipUserMap

while :
do
	rawIpUserMapping=$(tail -n200 /usr/local/openresty/nginx/logs/access.log \
	    | grep -E -o '^([0-9]{1,3}\.){3}([0-9]{1,3}) - \w+' \
	    | grep -P '^(?!127)' \
	    | cut -d' ' -f1,3 | sort | uniq \
	    | xargs -n2 bash -c 'echo "$0:$1"')
	   
	for line in $rawIpUserMapping
	do 
		k=$(echo $line | cut -d':' -f1)
		v=$(echo $line | cut -d':' -f2)
	
		numberOfSuccessfulAuths=$(grep --binary-files=text -cE "$v.*auth\.html\?app.* 200 "  /usr/local/openresty/nginx/logs/access.log)

        	[[ $numberOfSuccessfulAuths -gt 0 ]] && ipUserMap[$k]=$v
	done

	echo "Extracted mappings:"
	for v in ${!ipUserMap[@]}; do echo "$v:${ipUserMap[$v]}"; done
	echo -e "\n"

	connectedIps=$(curl --silent localhost/stat \
		| jq '."http-flv".servers[0].applications[0].live.streams[0].clients[] | select(.publishing==false) | .address' \
		| sed s/\"//g)
	echo "Connected users:"
	allClientsHtml="<h3>No clients connected.</h3>"
	for ip in $connectedIps
	do
		user=${ipUserMap[$ip]}
		echo $user
		asHtml=$(echo -e "<h3>\"$user\"($ip) connected</h3>\\n")
		[[ $allClientsHtml =~ "clients" ]] \
			&& allClientsHtml=$asHtml \
			|| allClientsHtml=$allClientsHtml"\n"$asHtml
	done

	OPENRESTY_PATH=/usr/local/openresty/nginx
	cat frontend/clients.html \
		| sed "s|+++CLIENTS_HTML+++|$allClientsHtml|g" \
		| sudo tee $OPENRESTY_PATH/clients.html > /dev/null

	sleep 15
done
