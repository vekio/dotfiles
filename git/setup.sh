#!/usr/bin/env bash


# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n"  '\e[0;32m\033[1m' '\e[0m' "$@" >&2; }
warn() { printf "%b[warn]%b %s\n"  '\e[0;33m\033[1m' '\e[0m' "$@" >&2; exit 0; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$@" >&2; exit 1; }


# source directory
# -----------------------------------------------------------------------------
SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) || error "source directory not found"


# check git install
# -----------------------------------------------------------------------------
git --version &>/dev/null && git flow version &>/dev/null && \
warn "git already setup" || info "setup git"


# install git & git-flow
# -----------------------------------------------------------------------------
sudo apt update &> /dev/null && \
sudo apt -y install \
    git \
    git-flow &>/dev/null || \
error "install git"


# create git symlinks
# -----------------------------------------------------------------------------
ln -fs "${SDIR}/gitconfig" "${HOME}/.gitconfig" && \
ln -fs "${SDIR}/gitconfig.user" "${HOME}/.gitconfig.user" || \
error "create git symlinks"
