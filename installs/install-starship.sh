#!/usr/bin/env bash
#
# Install starship.
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

# install starship
# -----------------------------------------------------------------------------
if command -v starship &>/dev/null; then
    warn "starship is already installed"; exit 1
fi
info "installing starship"

curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b ~/.local/bin &>/dev/null