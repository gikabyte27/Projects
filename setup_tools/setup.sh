#!/bin/bash

ZSH_CONFIG = $HOME/.zshrc
BASH_CONFIG = $HOME/.bashrc
PROFILE = $HOME/.profile
cat go.config >> $ZSH_CONFIG
cat go.config >> $BASH_CONFIG 
cat go.config >> $PROFILE
