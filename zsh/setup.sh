#!/usr/bin/env bash

# logger
loginfo() { printf "%b[info]%b %s\n"  '\e[0;32m\033[1m' '\e[0m' "$@" >&2; }
logwarn() { printf "%b[warn]%b %s\n"  '\e[0;33m\033[1m' '\e[0m' "$@" >&2; }

SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) || exit 1

# rc files
ln -sf "$SDIR/zshrc" ~/.zshrc
ln -sf "$SDIR/zshenv" ~/.zshenv

# starship setup
bash "$SDIR/../cli/starship/setup.sh" || logwarn "starship not installed correctly."

# install zsh
zsh --version &>/dev/null && loginfo "zsh already installed." && exit 0
sudo apt install -y zsh &>/dev/null && chsh -s $(which zsh) && exec zsh
