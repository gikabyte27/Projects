#!/bin/bash

apt update -y --force-yes && apt upgrade -y --force-yes
apt install -y --force-yes vim-gtk3 fzf xsel xclip
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cp .vimrc ~/.vimrc
cp .tmux.conf ~/.tmux.conf
