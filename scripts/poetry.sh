#!/usr/bin/env bash
#
# Installs or updates poetry.
set -euo pipefail
IFS=$'\n\t'

# Global variables
# -----------------------------------------------------------------------------
SCRIPT_NAME="$(basename ${0})"

# Loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
warn() { printf "%b[warn]%b %s\n" '\e[0;33m\033[1m' '\e[0m' "$*" >&2; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; }

# #######################################
# # Install or update poetry.
# # Arguments:
# #   None
# #######################################
function install_update_poetry () {
    if command -v poetry &>/dev/null; then
        poetry self update &>/dev/null || {
            error "update poetry"
            exit 1
        } && info "update poetry"
    else
        curl -sSL https://install.python-poetry.org | python3 - &>/dev/null || {
            error "install poetry"
            exit 1
        } && info "install poetry"
        ~/.local/bin/poetry completions zsh > ~/.zfunc/_poetry
        ~/.local/bin/poetry config virtualenvs.in-project true
    fi
}

# Main
# -----------------------------------------------------------------------------
function main () {
    install_update_poetry
}

main "$@"
