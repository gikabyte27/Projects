#!/bin/bash

apt install -y golang
ZSH_CONFIG=$HOME/.zshrc
BASH_CONFIG=$HOME/.bashrc
PROFILE=$HOME/.profile
cat go.config >> $ZSH_CONFIG
cat go.config >> $BASH_CONFIG 
cat go.config >> $PROFILE


go install -v github.com/haccer/subjack@latest
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/tomnomnom/assetfinder@latest

git clone https://github.com/devanshbatham/ParamSpider
pip3 install -r ParamSpider/requirements.txt
