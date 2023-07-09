# MiTM using ARP Spoofing

## Usage

```
1. git clone https://github.com/gikabyte27/Projects/ManInTheMiddle.git 
2. cd ManInTheMiddle
3. chmod +x arp_spoof.sh
4. ./arp_spoof.sh -i <interface> -t <target_ip>

```

If you want to use this in VirtualBox, make sure to have both machines in a specific ![NAT Network] you defined


The script will:
- enable IPv4 forward to your machine
- add iptables rule to ACCEPT network traffic passing through your main interface
- ARP spoof the target to think that you are the gateway (you get the packets from the target)
- ARP spoof the gateway to think that you are the target (you get the packets from the gateway)

