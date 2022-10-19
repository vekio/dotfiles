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

# check terraform
# -----------------------------------------------------------------------------
if command -v terraform &>/dev/null; then
    warn "terraform already installed"; exit;
fi
info "installing terraform"

# dependencies
# -----------------------------------------------------------------------------
packages=("gnupg" "software-properties-common" "wget")
${SUDO} apt update &> /dev/null || (error "update the package lists"; exit 1)
${SUDO} apt install -y ${packages[@]} &> /dev/null

# gpg key
wget -O- --quiet https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    ${SUDO} tee /usr/share/keyrings/hashicorp-archive-keyring.gpg &> /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    ${SUDO} tee /etc/apt/sources.list.d/hashicorp.list &> /dev/null

# # update & install terraform
${SUDO} apt update &> /dev/null || (error "update the package lists"; exit 1)
${SUDO} apt install -y terraform &> /dev/null
