#!/usr/bin/env bash


# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n"  '\e[0;32m\033[1m' '\e[0m' "$@" >&2; }
warn() { printf "%b[warn]%b %s\n"  '\e[0;33m\033[1m' '\e[0m' "$@" >&2; exit 0; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$@" >&2; exit 1; }


# source directory
# -----------------------------------------------------------------------------
SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) || error "source directory not found"


# check zsh install
# -----------------------------------------------------------------------------
zsh --version &>/dev/null && \
warn "zsh already setup" || info "setup zsh"


# install zsh package
# -----------------------------------------------------------------------------
sudo apt update &> /dev/null && \
sudo apt -y install \
    zsh &> /dev/null || \
error "install zsh package"


# install zsh plugins
# -----------------------------------------------------------------------------
bash "${SDIR}/update-zsh-plugins" &> /dev/null || \
error "install zsh plugins"


# create zsh directories
# -----------------------------------------------------------------------------
mkdir -p "${HOME}/.config/zsh" \
    "${HOME}/.cache/zsh" &> /dev/null || \
error "create zsh directories"


# create zsh symlinks
# -----------------------------------------------------------------------------
ln -fs "${SDIR}/zshenv" "${HOME}/.zshenv" && \
ln -fs "${SDIR}/zshrc" "${HOME}/.config/zsh/.zshrc" && \
ln -fs "${SDIR}/aliases" "${HOME}/.config/zsh/.aliases" && \
ln -fs "${SDIR}/update-zsh-plugins" "${HOME}/.local/bin/update-zsh-plugins" || \
error "create zsh symlinks"


# change to zsh
# -----------------------------------------------------------------------------
zsh --version &>/dev/null && chsh -s "$(command -v zsh)" || \
error "change to zsh" && info "change to zsh, open a new terminal"
