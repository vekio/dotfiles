#!/usr/bin/env bash
#
# Install or update nvm and nodejs.
set -euo pipefail
IFS=$'\n\t'

# global variables
# -----------------------------------------------------------------------------
unset SCRIPT_NAME
SCRIPT_NAME="$(basename ${0})"
NVM_VERSION="v0.39.2"
# TODO
# get_latest_release() {
#   curl --silent "https://api.github.com/repos/$1/releases/latest" |
#     grep '"tag_name":' |
#     sed -E 's/.*"([^"]+)".*/\1/'
# }

# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
warn() { printf "%b[warn]%b %s\n" '\e[0;33m\033[1m' '\e[0m' "$*" >&2; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; }

#######################################
# Install nvm.
# Globals:
#   NVM_VERSION
# Arguments:
#   None
#######################################
function install_nvm () {
    curl -o- -s https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash
}

#######################################
# Update nvm.
# Globals:
#   NVM_VERSION
# Arguments:
#   None
#######################################
function update_nvm () {
    curl -o- -s https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash
}

#######################################
# Install nodejs.
# Arguments:
#   None
#######################################
function install_node () {
    nvm install --lts
}

#######################################
# Update nodejs.
# Arguments:
#   None
#######################################
function update_node () {
    nvm install --lts --reinstall-packages-from=$(nvm current)
}

# main
# -----------------------------------------------------------------------------
function main () {
    # load nvm if exists
    NVM_DIR="$([[ -z "${XDG_CONFIG_HOME-}" ]] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [[ -s "${NVM_DIR}/nvm.sh" ]] && \. "${NVM_DIR}/nvm.sh"

    if ! command -v nvm &>/dev/null; then
        info "installing nvm" && install_nvm
    else
        warn "updating nvm" && update_nvm
    fi

    if ! command -v node &>/dev/null; then
        info "installing node" && install_node
    else
        warn "updating node" && update_node
    fi
}
main "$@"
