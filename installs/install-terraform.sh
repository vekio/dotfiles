#!/usr/bin/env bash
#
# Install terraform.
set -euo pipefail
IFS=$'\n\t'

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

# dependencies
# -----------------------------------------------------------------------------
packages=("gnupg" "software-properties-common" "curl")
if [[ "${EUID}" -eq 0 ]]; then
    apt update &> /dev/null || (error "update the package lists"; exit 1)
    apt install -y ${packages[@]} &> /dev/null
else
    sudo apt update &> /dev/null || (error "update the package lists"; exit 1)
    sudo apt install -y ${packages[@]}  &> /dev/null
fi

# gpg key
wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list

# update & install terraform
if [[ "${EUID}" -eq 0 ]]; then
    apt update &> /dev/null || (error "update the package lists"; exit 1)
    apt install -y terraform &> /dev/null
else
    sudo apt update &> /dev/null || (error "update the package lists"; exit 1)
    sudo apt install -y terraform  &> /dev/null
fi
