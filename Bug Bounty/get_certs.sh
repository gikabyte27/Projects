#!/bin/bash

if [ $# -ne 1 ];then
	echo "Usage: $0 <target_domain>"
	exit
fi
echo "[+] Finding certificates for $1..."
curl -s https://crt.sh/\?q\=%25.$1\&output=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u
