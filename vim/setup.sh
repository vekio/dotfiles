#!/usr/bin/env bash
#
# Setup vim.
set -euo pipefail
IFS=$'\n\t'

# install plug (vim plugin manager)
# -----------------------------------------------------------------------------
curl -fLo "${HOME}/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
