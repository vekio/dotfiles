#!/usr/bin/env bash
#
# Install fzf.
set -euo pipefail
IFS=$'\n\t'

# global variables
# -----------------------------------------------------------------------------
unset SCRIPT_NAME
SCRIPT_NAME="$(basename ${0})"

# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
warn() { printf "%b[warn]%b %s\n" '\e[0;33m\033[1m' '\e[0m' "$*" >&2; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; }

# install fzf
# -----------------------------------------------------------------------------
if [[ -d "${HOME}/.local/share/fzf" ]]; then
    warn "fzf is already installed"; exit
fi
info "installing fzf"

git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.local/share/fzf" && \
    yes | "${HOME}/.local/share/fzf/install" --bin --no-update-rc
