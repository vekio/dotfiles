#!/usr/bin/env bash
#
#
set -euo pipefail
IFS=$'\n\t'

# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
warn() { printf "%b[warn]%b %s\n" '\e[0;33m\033[1m' '\e[0m' "$*" >&2; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; }

# source directory
# -----------------------------------------------------------------------------
SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

info "zsh setup"

# create zsh directories
# -----------------------------------------------------------------------------
mkdir -p "${HOME}/.config/zsh" "${HOME}/.cache/zsh"

# create zsh symlinks
# -----------------------------------------------------------------------------
ln -fs "${SDIR}/zshenv" "${HOME}/.zshenv"
ln -fs "${SDIR}/zshrc" "${HOME}/.config/zsh/.zshrc"
ln -fs "${SDIR}/aliases" "${HOME}/.config/zsh/.aliases"

# change to zsh
# -----------------------------------------------------------------------------
if ! command -v zsh &>/dev/null; then
    exit 1
else
    chsh -s "$(command -v zsh)"
fi

exec bash -l
