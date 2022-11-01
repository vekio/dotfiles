#!/usr/bin/env bash
#
# Install or update fzf.
set -euo pipefail
IFS=$'\n\t'

# global variables
# -----------------------------------------------------------------------------
unset SCRIPT_NAME
SCRIPT_NAME="$(basename ${0})"
FZF_PATH="${HOME}/.local/share/fzf"

# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
warn() { printf "%b[warn]%b %s\n" '\e[0;33m\033[1m' '\e[0m' "$*" >&2; }
error() { printf "%b[error]%b %s (%s)\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; }

# functions
# -----------------------------------------------------------------------------
#######################################
# Install fzf.
# Globals:
#   FZF_PATH
# Arguments:
#   None
#######################################
function install_fzf () {
    git clone --depth 1 https://github.com/junegunn/fzf.git ${FZF_PATH} && \
        "${FZF_PATH}/install" --bin --no-update-rc
}

#######################################
# Update fzf.
# Globals:
#   FZF_PATH
# Arguments:
#   None
#######################################
function update_fzf () {
    cd ${FZF_PATH} && git pull && ./install --bin --no-update-rc
    cd -  &> /dev/null
}

# main
# -----------------------------------------------------------------------------
function main () {
    if ! [[ -d "${HOME}/.local/share/fzf" ]]; then
        info "installing fzf"
        install_fzf
    else
        warn "updating fzf"
        update_fzf
    fi
}
main "$@"
