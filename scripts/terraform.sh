#!/usr/bin/env bash
#
# Installs terraform.
set -euo pipefail
IFS=$'\n\t'

# global variables
# -----------------------------------------------------------------------------
SCRIPT_NAME="$(basename ${0})"
SUDO=""; command -v sudo &>/dev/null && SUDO="sudo"

# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
warn() { printf "%b[warn]%b %s\n" '\e[0;33m\033[1m' '\e[0m' "$*" >&2; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; }

#######################################
# Install terraform.
# Globals:
#   SUDO
# Arguments:
#   None
#######################################
function install_terraform () {

    if command -v terraform &>/dev/null; then
        warn "terraform already installed, use package manager to update"
    else
        # dependencies
        packages=("gnupg" "software-properties-common" "wget")
        ${SUDO} apt update &>/dev/null && \
        ${SUDO} apt install -y ${packages[@]} &>/dev/null || {
            error "install terraform dependencies"
            exit 1
        }

        # gpg key
        wget -O- --quiet https://apt.releases.hashicorp.com/gpg | \
            gpg --dearmor | \
            ${SUDO} tee /usr/share/keyrings/hashicorp-archive-keyring.gpg &>/dev/null

        echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
            https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
            ${SUDO} tee /etc/apt/sources.list.d/hashicorp.list &>/dev/null

        # update & install terraform
        ${SUDO} apt update &>/dev/null && \
        ${SUDO} apt install -y terraform &>/dev/null || {
            error "install terraform"
            exit 1
        } && info "install terraform"
    fi
}

# main
# -----------------------------------------------------------------------------
function main () {
    install_terraform
}
main "$@"
