#!/bin/bash

if [ $# -ne 1 ];then
	echo "Usage: $0 <target_domain>"
	exit
fi

URL=$1
dest_path=$URL/recon/


echo "[+] Harvesting subdomains with assetfinder..."

if [ ! -d "$URL" ]; then
	mkdir $URL
	echo "[+] $URL folder not existing, creating it..."
fi

if [ ! -d "$URL/recon" ]; then
	mkdir $URL/recon
	echo "[+] $URL/recon folder not existing, creating it..."
fi

# Better to use assetfinder with nothing and grep afterwards
# assetfinder tends to get results from related resources as well
assetfinder $URL > $dest_path/assets.txt
cat $dest_path/assets.txt | grep $1 | sort | uniq > $dest_path/subdomains.txt
cat $dest_path/assets.txt | grep -v $1 | sort | uniq > $dest_path/ommitted.txt

rm $dest_path/assets.txt

found=$(cat $dest_path/subdomains.txt | wc -l)
ommitted=$(cat $dest_path/ommitted.txt | wc -l)

echo "[+] After grep there are $found subs"

echo "[+] Sucessfully found $found subdomains!"
echo "[+] Subdomains ommitted: $ommitted"

echo "[+] All files are accessible in $PWD/$dest_path"
