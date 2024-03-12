#!/bin/bash


if [ $# -ne 1 ];then
        echo "Usage: $0 <AS[0-9]>"
        exit
fi
whois -h whois.radb.net -- -i origin $1 | grep -Eo "([0-9.]+){4}/[0-9]+" | sort -u
