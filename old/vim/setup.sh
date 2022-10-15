#!/usr/bin/env bash


# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n"  '\e[0;32m\033[1m' '\e[0m' "$@" >&2; }
warn() { printf "%b[warn]%b %s\n"  '\e[0;33m\033[1m' '\e[0m' "$@" >&2; exit 0; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$@" >&2; exit 1; }


# source directory
# -----------------------------------------------------------------------------
SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) || error "source directory not found"


info "setup vim"


# install neovim
# -----------------------------------------------------------------------------
sudo apt update &> /dev/null && \
sudo apt -y install \
    neovim &>/dev/null || \
error "install neovim"


# install plug (vim plugin manager)
# -----------------------------------------------------------------------------
curl -fLo "${HOME}/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &> /dev/null || \
error "install plug"
