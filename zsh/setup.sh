#!/usr/bin/env bash
#
# Config zsh.
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

# check zsh
# -----------------------------------------------------------------------------
if ! command -v zsh &>/dev/null; then
    error "zsh is not installed"; exit 1
fi
info "setting up zsh"

# create zsh directories
# -----------------------------------------------------------------------------
mkdir -p "${HOME}/.config/zsh" \
    "${HOME}/.cache/zsh"

# create zsh symlinks
# -----------------------------------------------------------------------------
ln -fs "${SRCDIR}/zshenv" "${HOME}/.zshenv"
ln -fs "${SRCDIR}/zshrc" "${HOME}/.config/zsh/.zshrc"
ln -fs "${SRCDIR}/aliases" "${HOME}/.config/zsh/.aliases"
ln -fs "${SRCDIR}/helpers" "${HOME}/.config/zsh/.helpers"

# change to zsh
# -----------------------------------------------------------------------------
chsh -s "$(command -v zsh)" && warn "open a new terminal to change the shell to zsh"
# exec bash -l
