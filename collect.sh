#!/bin/bash
#
##################################################################################################################
# Name         :  collect.sh
# Author       :  vekio
# Description  :  collect all the settings file from their source
# Notes        :  
##################################################################################################################

# vscode/snippets/*
cp -r ~/.config/Code/User/snippets/ ./vscode/

# vscode/settings.json
cp ~/.config/Code/User/settings.json ./vscode/
