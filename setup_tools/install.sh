#!/bin/bash

sudo apt-get update -y --force-yes && sudo apt-get -y --force-yes install netcat-openbsd net-tools bmon tcpdump tmux python3-full python3-pip
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
go install -v github.com/ffuf/ffuf/v2@latest

git clone https://github.com/devanshbatham/ParamSpider /opt/ParamSpider
wget -c https://github.com/danielmiessler/SecLists/archive/master.zip -O /usr/share/SecList.zip \
	  && unzip /usr/share/SecList.zip -d /usr/share/ \
		  && rm -f /usr/share/SecList.zip \
			&& mv /usr/share/SecLists-master/ /usr/share/seclists
pip3 install /opt/ParamSpider/ --break-system-packages

pip install git+https://github.com/blacklanternsecurity/trevorproxy --break-system-packages
pip install git+https://github.com/blacklanternsecurity/trevorspray --break-system-packages

#apt install slapd ldap-utils && sudo systemctl enable slapd
