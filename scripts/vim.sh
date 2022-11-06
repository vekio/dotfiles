#!/usr/bin/env bash
#
# Config vim.
set -euo pipefail
IFS=$'\n\t'

# global variables
# -----------------------------------------------------------------------------
SCRIPT_NAME="$(basename ${0})"

# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
warn() { printf "%b[warn]%b %s\n" '\e[0;33m\033[1m' '\e[0m' "$*" >&2; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; }

#######################################
# Setup vim.
# Globals:
#   HOME
# Arguments:
#   None
#######################################
function setup_vim () {
    # plugin manager
    curl -fLo "${HOME}/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &>/dev/null || {
            error "setup vim"
            exit 1
        } && info "setup vim"
}

# main
# -----------------------------------------------------------------------------
function main () {
    setup_vim
}
main "$@"
