#!/bin/bash

sudo apt-get update -y --force-yes && sudo apt-get -y --force-yes install slapd ldap-utils netcat-openbsd net-tools bmon tcpdump tmux && sudo systemctl enable slapd
apt install -y golang
ZSH_CONFIG=$HOME/.zshrc
BASH_CONFIG=$HOME/.bashrc
PROFILE=$HOME/.profile

source $PROFILE



cat go.config >> $ZSH_CONFIG
cat go.config >> $BASH_CONFIG 
cat go.config >> $PROFILE


go install -v github.com/haccer/subjack@latest
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/tomnomnom/assetfinder@latest

git clone https://github.com/devanshbatham/ParamSpider /opt/ParamSpider
pip3 install -r /opt/ParamSpider/requirements.txt

pip install git+https://github.com/blacklanternsecurity/trevorproxy
pip install git+https://github.com/blacklanternsecurity/trevorspray


