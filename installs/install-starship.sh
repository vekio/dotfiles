#!/usr/bin/env bash
#
# Install starship.
set -euo pipefail
IFS=$'\n\t'

# global variables
# -----------------------------------------------------------------------------
unset SCRIPT_NAME
SCRIPT_NAME="$(basename ${0})"
STARSHIP_PATH="${HOME}/.local/bin"

# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
warn() { printf "%b[warn]%b %s\n" '\e[0;33m\033[1m' '\e[0m' "$*" >&2; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; }

#######################################
# Install starship.
# Arguments:
#   None
#######################################
function install_starship () {
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b ${STARSHIP_PATH}
}

#######################################
# Update starship.
# Arguments:
#   None
#######################################
function update_starship () {
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b ${STARSHIP_PATH}
}

# main
# -----------------------------------------------------------------------------
function main () {
    # folder
    [[ -d "${STARSHIP_PATH}" ]] || mkdir -p ${STARSHIP_PATH}

    if ! command -v starship &>/dev/null; then
        info "installing starship" #&& install_starship
    else
        warn "updating starship" #&& update_starship
    fi
}
main "$@"
