#!/usr/bin/env bash

# logger
loginfo() { printf "%b[info]%b %s\n"  '\e[0;32m\033[1m' '\e[0m' "$@" >&2; }

make --version &>/dev/null && loginfo "make already installed." && exit 0
sudo apt -y install build-essential
