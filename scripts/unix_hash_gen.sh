#!/bin/bash
#
if [ $# -ne 1 ]; then
	echo "Usage: $0 <password>"
	exit 1
fi
hash=$(openssl passwd -6 -salt "$(openssl rand -hex 6)" "$1")
echo "================================"
echo -e "Hashes password: \n$hash"
echo "================================"
echo -e "Shadow entry: \ngikabyte:$hash:19742:0:99999:7:::"
echo "================================"
