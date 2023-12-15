#!/bin/bash

apt update --yes --force-yes && apt upgrade --yes --force-yes
apt install vim-gtk3
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cp .vimrc ~/.vimrc
cp .tmux.conf ~/.tmux.conf
