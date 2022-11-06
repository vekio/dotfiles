#!/usr/bin/env bash
#
# Installs and setup fzf.
set -euo pipefail
IFS=$'\n\t'

# global variables
# -----------------------------------------------------------------------------
SCRIPT_NAME="$(basename ${0})"
SRC_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
FZF_PATH="${HOME}/.local/share/fzf"

# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
warn() { printf "%b[warn]%b %s\n" '\e[0;33m\033[1m' '\e[0m' "$*" >&2; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; }

#######################################
# Install or update fzf.
# Globals:
#   FZF_PATH
# Arguments:
#   None
#######################################
function install_update_fzf () {
    if command -v fzf &>/dev/null; then
        cd ${FZF_PATH} && \
        git pull &>/dev/null && \
        ./install --bin --no-update-rc &>/dev/null || {
            error "update fzf"
            exit 1
        } && info "update fzf"
        cd - &> /dev/null
    else
        if [[ -d "${FZF_PATH}" ]]; then
            warn "fzf folder already exists"
        else
            git clone --depth 1 https://github.com/junegunn/fzf.git ${FZF_PATH} &>/dev/null && \
                "${FZF_PATH}/install" --bin --no-update-rc &>/dev/null || {
                error "install fzf"
                exit 1
            } && info "install fzf"
        fi
    fi
}

#######################################
# Setup fzf.
# Globals:
#   SRC_DIR
#   HOME
# Arguments:
#   None
#######################################
function setup_fzf () {
    ln -sf "${SRC_DIR}/../fzf/fzf" "${HOME}/.config/zsh/.fzf" || {
        error "setup fzf"
        exit 1
    } && info "setup fzf"
}

# main
# -----------------------------------------------------------------------------
function main () {
    install_update_fzf
    setup_fzf
}
main "$@"
