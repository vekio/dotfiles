#!/usr/bin/env bash


# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n"  '\e[0;32m\033[1m' '\e[0m' "$@" >&2; }
warn() { printf "%b[warn]%b %s\n"  '\e[0;33m\033[1m' '\e[0m' "$@" >&2; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$@" >&2; exit 1; }


# source directory
# -----------------------------------------------------------------------------
SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) || error "source directory not found"


# create git symlinks
# -----------------------------------------------------------------------------
ln -fs "${SDIR}/gitconfig" "${HOME}/.gitconfig" && \
ln -fs "${SDIR}/gitconfig.user" "${HOME}/.gitconfig.user"

[ ${?} -eq 0 ] && info "create git symlinks" || error "can't create git symlinks"
