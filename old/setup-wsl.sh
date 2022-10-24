#!/usr/bin/env bash


# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n"  '\e[0;32m\033[1m' '\e[0m' "$@" >&2; }
warn() { printf "%b[warn]%b %s\n"  '\e[0;33m\033[1m' '\e[0m' "$@" >&2; exit 0; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$@" >&2; exit 1; }


# source directory
# -----------------------------------------------------------------------------
SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) || error "source directory not found"


info "setting up WSL2 ..."


# update && upgrade
# -----------------------------------------------------------------------------
sudo apt update &> /dev/null && \
sudo apt -y upgrade &> /dev/null || \
error "update & upgrade"


# install packages
# -----------------------------------------------------------------------------
sudo apt update &> /dev/null && \
sudo apt -y install \
    build-essential \
    zip \
    tree &> /dev/null || \
error "install packages"


# create directories
# -----------------------------------------------------------------------------
mkdir -p "${HOME}/.config" \
    "${HOME}/.cache" \
    "${HOME}/.local/bin" \
    "${HOME}/.local/share" \
    "${HOME}/.local/state" \
    "${HOME}/projects" &> /dev/null || \
error "create directories"

# setup
# -----------------------------------------------------------------------------
# git
bash "${SDIR}/git/setup.sh"

# zsh
bash "${SDIR}/zsh/setup.sh"

# starship
bash "${SDIR}/starship/setup.sh"

# terraform
bash "${SDIR}/terraform/setup.sh"

# vim
bash "${SDIR}/vim/setup.sh"

# fzf
bash "${SDIR}/fzf/setup.sh"

# miniconda3
bash "${SDIR}/miniconda3/setup.sh"

# ssh
bash "${SDIR}/ssh/setup.sh"

# nvm
bash "${SDIR}/nvm/setup.sh"
