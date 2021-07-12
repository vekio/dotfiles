#!/usr/bin/env bash

SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) || exit 1

mkdir -p ~/.config
ln -sf "$SDIR/starship.toml" ~/.config/

starship --version &>/dev/null && loginfo "starship already installed." && exit 0

mkdir -p ~/bin && curl -fsSL https://starship.rs/install.sh | bash -s -- -y -b ~/bin
