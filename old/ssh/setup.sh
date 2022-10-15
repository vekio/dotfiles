#!/usr/bin/env bash


# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n"  '\e[0;32m\033[1m' '\e[0m' "$@" >&2; }
warn() { printf "%b[warn]%b %s\n"  '\e[0;33m\033[1m' '\e[0m' "$@" >&2; exit 0; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$@" >&2; exit 1; }


info "setup ssh"


# setup ssh
# -----------------------------------------------------------------------------
mkdir -p ~/.ssh && chmod 700 ~/.ssh
touch ~/.ssh/config && chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/* &> /dev/null
chmod 644 ~/.ssh/*.pub &> /dev/null
