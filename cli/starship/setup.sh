#!/usr/bin/env bash

# logger
loginfo() { printf "%b[info]%b %s\n"  '\e[0;32m\033[1m' '\e[0m' "$@" >&2; }
logwarn() { printf "%b[warn]%b %s\n"  '\e[0;33m\033[1m' '\e[0m' "$@" >&2; }

SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) || exit 1

# toml
mkdir -p ~/.config
ln -sf "$SDIR/starship.toml" ~/.config/

# install starship
starship --version &>/dev/null && loginfo "starship already installed." && exit 0
mkdir -p ~/bin && curl -fsSL https://starship.rs/install.sh | bash -s -- -y -b ~/bin &>/dev/null
