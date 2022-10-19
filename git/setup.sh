#!/usr/bin/env bash
#
# Config git.
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

# check git
# -----------------------------------------------------------------------------
if ! command -v git &>/dev/null; then
    error "git is not installed"; exit 1
fi
info "setting up git"

# git config
# -----------------------------------------------------------------------------
git config --global user.name "Alberto Castañeiras"
git config --global user.email "alberto@casta.me"

# git config --global includeIf."gitdir:~/mz/".path ~/mz/.gitconfig
