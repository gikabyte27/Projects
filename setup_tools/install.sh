#!/bin/bash

sudo apt-get update -y --force-yes && sudo apt-get -y --force-yes install netcat-openbsd net-tools bmon tcpdump tmux python3-full python3-pip nmap ffuf chromium
apt install -y golang
ZSH_CONFIG=$HOME/.zshrc
BASH_CONFIG=$HOME/.bashrc
PROFILE=$HOME/.profile




cat go.config >> $ZSH_CONFIG
cat go.config >> $BASH_CONFIG 
cat go.config >> $PROFILE

source $PROFILE

go install -v github.com/haccer/subjack@latest
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/tomnomnom/assetfinder@latest
go install -v github.com/tomnomnom/httprobe@latest
go install -v github.com/owasp-amass/amass/v4/...@master
go install -v github.com/sensepost/gowitness@latest

git clone https://github.com/devanshbatham/ParamSpider /opt/ParamSpider
git clone https://github.com/aboul3la/Sublist3r.git /opt/Sublist3r && pip install -r /opt/Sublist3r/requirements.txt --break-system-packages && pip3 install /opt/Sublist3r/ --break-system-packages
wget -c https://github.com/danielmiessler/SecLists/archive/master.zip -O /usr/share/SecList.zip \
	  && unzip /usr/share/SecList.zip -d /usr/share/ \
		  && rm -f /usr/share/SecList.zip \
			&& mv /usr/share/SecLists-master/ /usr/share/seclists
pip3 install /opt/ParamSpider/ --break-system-packages

pip install git+https://github.com/blacklanternsecurity/trevorproxy --break-system-packages
pip install git+https://github.com/blacklanternsecurity/trevorspray --break-system-packages

#apt install slapd ldap-utils && sudo systemctl enable slapd
