#!/usr/bin/env bash
#
# Config zsh.
set -euo pipefail
IFS=$'\n\t'

# global variables
# -----------------------------------------------------------------------------
SCRIPT_NAME="$(basename ${0})"
SRC_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
warn() { printf "%b[warn]%b %s\n" '\e[0;33m\033[1m' '\e[0m' "$*" >&2; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; }

#######################################
# Setup zsh.
# Globals:
#   HOME
#   SRC_DIR
# Arguments:
#   None
#######################################
function setup_zsh () {
    mkdir -p "${HOME}/.config/zsh" \
        "${HOME}/.cache/zsh"

    ln -fs "${SRC_DIR}/../zsh/zshenv" "${HOME}/.zshenv" && \
    ln -fs "${SRC_DIR}/../zsh/zshrc" "${HOME}/.config/zsh/.zshrc" && \
    ln -fs "${SRC_DIR}/../zsh/aliases" "${HOME}/.config/zsh/.aliases" && \
    ln -fs "${SRC_DIR}/../zsh/helpers" "${HOME}/.config/zsh/.helpers" || {
        error "setup zsh"
        exit 1
    } && info "setup zsh"

    # sudo chsh -s "$(command -v zsh)"
    # exec zsh -l
}

# main
# -----------------------------------------------------------------------------
function main () {
    setup_zsh
}
main "$@"
