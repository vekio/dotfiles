#!/usr/bin/env bash
#
#
set -euo pipefail
IFS=$'\n\t'

# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
warn() { printf "%b[warn]%b %s\n" '\e[0;33m\033[1m' '\e[0m' "$*" >&2; }
erro() { printf "%b[erro]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; exit 1; }

# source directory
# -----------------------------------------------------------------------------
SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

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
    erro "zsh is not installed"
else
    chsh -s "$(command -v zsh)"
    info "change to zsh, open a new terminal"
fi
