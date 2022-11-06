#!/usr/bin/env bash
#
# Installs, updates and setup starship.
set -euo pipefail
IFS=$'\n\t'

# global variables
# -----------------------------------------------------------------------------
SCRIPT_NAME="$(basename ${0})"
SRC_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
STARSHIP_PATH="${HOME}/.local/bin"

# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
warn() { printf "%b[warn]%b %s\n" '\e[0;33m\033[1m' '\e[0m' "$*" >&2; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; }

#######################################
# Install or update starship.
# Globals:
#   STARSHIP_PATH
# Arguments:
#   None
#######################################
function install_update_starship () {
    if command -v starship &>/dev/null; then
        curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b ${STARSHIP_PATH} &>/dev/null || {
            error "update starship"
            exit 1
        } && info "update starship"
    else
        curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b ${STARSHIP_PATH} &>/dev/null || {
            error "install starship"
            exit 1
        } && info "install starship"
    fi
}

#######################################
# Setup starship.
# Globals:
#   SRC_DIR
#   HOME
# Arguments:
#   None
#######################################
function setup_starship () {
    ln -sf "${SRC_DIR}/../starship/starship.toml" "${HOME}/.config/starship.toml" || {
        error "setup starship"
        exit 1
    } && info "setup starship"
}

# main
# -----------------------------------------------------------------------------
function main () {
   install_update_starship
    setup_starship
}
main "$@"
