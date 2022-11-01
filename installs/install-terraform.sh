#!/usr/bin/env bash
#
# Install terraform.
set -euo pipefail
IFS=$'\n\t'

# global variables
# -----------------------------------------------------------------------------
unset SCRIPT_NAME
SCRIPT_NAME="$(basename ${0})"
SUDO="sudo"; [[ "${EUID}" -eq 0 ]] && SUDO=""

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
    # dependencies
    packages=("gnupg" "software-properties-common" "wget")
    ${SUDO} apt update && \
    ${SUDO} apt install -y ${packages[@]}

    # gpg key
    wget -O- --quiet https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    ${SUDO} tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    ${SUDO} tee /etc/apt/sources.list.d/hashicorp.list

    # update & install terraform
    ${SUDO} apt update && \
    ${SUDO} apt install -y terraform
}

#######################################
# Update terraform.
# Globals:
#   SUDO
# Arguments:
#   None
#######################################
function update_terraform () {
    ${SUDO} apt update && \
    ${SUDO} apt install -y terraform
}

# main
# -----------------------------------------------------------------------------
function main () {
    if ! command -v terraform &>/dev/null; then
        info "installing terraform" && install_terraform
    else
        warn "updating terraform" && update_terraform
    fi
}
main "$@"
