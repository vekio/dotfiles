#!/usr/bin/env bash


# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n"  '\e[0;32m\033[1m' '\e[0m' "$@" >&2; }
warn() { printf "%b[warn]%b %s\n"  '\e[0;33m\033[1m' '\e[0m' "$@" >&2; exit 0; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$@" >&2; exit 1; }


# source directory
# -----------------------------------------------------------------------------
SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) || error "source directory not found"


# check starship install
# -----------------------------------------------------------------------------
starship --version &>/dev/null && \
warn "starship already setup" || info "setup starship"


# install starship
# -----------------------------------------------------------------------------
curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b ~/.local/bin &>/dev/null || \
error "install starship"


# create starship symlinks
# -----------------------------------------------------------------------------
ln -sf "${SDIR}/starship.toml" "${HOME}/.config/starship.toml" || \
error "create starship symlinks"
