#!/usr/bin/env bash
#
# Setup git.
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
# Setup git.
# Globals:
#   HOME
# Arguments:
#   None
#######################################
function setup_git () {
    if ! command -v git &> /dev/null;then
        error "git is not installed"
        exit 1
    else
        git config --global user.name "Alberto Castañeiras" && \
        git config --global user.email "alberto@casta.me" || {
            error "setup git"
            exit 1
        } && info "setup git"
    fi
    # git config --global includeIf."gitdir:~/mz/".path ~/mz/.gitconfig
}

# main
# -----------------------------------------------------------------------------
function main () {
    setup_git
}
main "$@"
