#!/usr/bin/env bash
#
# Setup starship.
set -euo pipefail
IFS=$'\n\t'

# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
warn() { printf "%b[warn]%b %s\n" '\e[0;33m\033[1m' '\e[0m' "$*" >&2; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; }

# source directory
# -----------------------------------------------------------------------------
SRCDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# check starship
# -----------------------------------------------------------------------------
if ! command -v starship &>/dev/null; then
    error "starship is not installed"; exit 1
fi
info "setting up starship"

# create zsh symlinks
# -----------------------------------------------------------------------------
ln -sf "${SRCDIR}/starship.toml" "${HOME}/.config/starship.toml"
