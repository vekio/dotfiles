#!/usr/bin/env bash
#
# Installs or updates nodejs.
set -euo pipefail
IFS=$'\n\t'

# global variables
# -----------------------------------------------------------------------------
SCRIPT_NAME="$(basename ${0})"
# nvm
NVM_VERSION=""

# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
warn() { printf "%b[warn]%b %s\n" '\e[0;33m\033[1m' '\e[0m' "$*" >&2; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; }

# helpers
# -----------------------------------------------------------------------------
function get_nvm_version () {
    NVM_VERSION=$(curl --silent "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
}
function load_nvm () {
    NVM_DIR="$([[ -z "${XDG_CONFIG_HOME-}" ]] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [[ -s "${NVM_DIR}/nvm.sh" ]] && . "${NVM_DIR}/nvm.sh"
    echo &>/dev/null
}

# #######################################
# # Install nvm.
# # Arguments:
# #   None
# #######################################
function install_nvm () {
    get_nvm_version
    curl -o- -s https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash &>/dev/null || {
        error "install nvm"
        exit 1
    } && info "install nvm"
}

# #######################################
# # Install or update nodejs.
# # Arguments:
# #   None
# #######################################
function install_update_nodejs () {
    load_nvm
    if ! command -v nvm &>/dev/null; then
        install_nvm
        load_nvm
    fi
    if command -v node &>/dev/null; then
        nvm install --lts --reinstall-packages-from=$(nvm current) &>/dev/null || {
            warn "nodejs already last version"
        } && info "update nodejs"
    else
        nvm install --lts &>/dev/null || {
            error "install nodejs"
            exit 1
        } && info "install nodejs"
    fi
}

# main
# -----------------------------------------------------------------------------
function main () {
    install_update_nodejs
}
main "$@"
