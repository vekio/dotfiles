#!/usr/bin/env bash

# logger
loginfo() { printf "%b[info]%b %s\n"  '\e[0;32m\033[1m' '\e[0m' "$@" >&2; }

SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) || exit 1

# gitconfig
ln -sf "$SDIR/gitconfig" ~/.gitconfig

# install
git --version &>/dev/null && loginfo "git already installed." && exit 0
sudo apt -y install git

# global config
#git config --global user.name "Alberto Castañeiras"
#git config --global user.email "alberto@casta.me"
