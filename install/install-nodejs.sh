#!/usr/bin/env bash

# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n"  '\e[0;32m\033[1m' '\e[0m' "$@" >&2; }
warn() { printf "%b[warn]%b %s\n"  '\e[0;33m\033[1m' '\e[0m' "$@" >&2; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$@" >&2; exit 1; }


# install nvm
# -----------------------------------------------------------------------------
nvm_version="v0.39.2"
info "install nvm"
curl -o- -s https://raw.githubusercontent.com/nvm-sh/nvm/${nvm_version}/install.sh | bash


# install nodejs
# -----------------------------------------------------------------------------
if [ -z "$1" ]; then
    info "install latest lts nodejs"
    nvm install --lts
else
    info "install nodejs ${1}"
    nvm install ${1}
fi
