#!/usr/bin/env bash

# logger
loginfo() { printf "%b[info]%b %s\n"  '\e[0;32m\033[1m' '\e[0m' "$@" >&2; }

conda --version &>/dev/null && loginfo "conda already installed." && exit 0

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh

bash /tmp/miniconda.sh -b -u -p ~/.local/miniconda3
rm /tmp/miniconda.sh

~/.local/miniconda3/bin/conda update conda && ~/.local/miniconda3/bin/conda init zsh && source ~/.config/zsh/.zshrc
rm ~/.zshrc
