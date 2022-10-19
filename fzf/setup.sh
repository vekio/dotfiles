#!/usr/bin/env bash
#
# Config fzf.
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

info "setting up fzf"

# create fzf symlinks
# -----------------------------------------------------------------------------
ln -sf "${SRCDIR}/fzf" "${HOME}/.config/zsh/.fzf"
