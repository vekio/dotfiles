#!/usr/bin/env bash

wget -P /tmp/ https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

bash /tmp/Miniconda3-latest-Linux-x86_64.sh

source ~/.bashrc
conda config --set auto_activate_base false
source ~/.bashrc
