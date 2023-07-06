#!/bin/bash
host=192.168.56.101
for port in {1..65535}; do
	timeout .1 bash -c "echo > /dev/tcp/$host/$port 2> /dev/null" 2> /dev/null &&
	echo "port $port is open"
done
echo "Done"
