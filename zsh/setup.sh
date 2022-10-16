#!/usr/bin/env bash
#
# Config zsh files.
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

# check zsh
# -----------------------------------------------------------------------------
if ! command -v zsh &>/dev/null; then
    exit 1
fi

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
chsh -s "$(command -v zsh)" && info "shell changed to zsh, to open a new terminal run: exec bash"
exec bash -l
