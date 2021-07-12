#!/usr/bin/env bash

SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) || exit 1

ln -sf "$SDIR/zshrc" ~/.zshrc

source ~/.zshrc
