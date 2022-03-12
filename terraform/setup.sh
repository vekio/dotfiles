#!/usr/bin/env bash

# install terraform linux ubuntu/debian
# https://learn.hashicorp.com/tutorials/terraform/install-cli

# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n"  '\e[0;32m\033[1m' '\e[0m' "$@" >&2; }
warn() { printf "%b[warn]%b %s\n"  '\e[0;33m\033[1m' '\e[0m' "$@" >&2; exit 0; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$@" >&2; exit 1; }


# source directory
# -----------------------------------------------------------------------------
SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) || error "source directory not found"


# check terraform install
# -----------------------------------------------------------------------------
terraform --version &>/dev/null && \
warn "terraform already setup" || info "setup terraform"


# install terraform
# -----------------------------------------------------------------------------
sudo apt update &> /dev/null && \
sudo apt -y install \
    gnupg \
    software-properties-common \
    curl &>/dev/null || \
error "install terraform packages dependencies"

# gpg key
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - &>/dev/null || \
error "add terraform gpg key"

# repository
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" &>/dev/null || \
error "add terraform repository"

# update & install
sudo apt update &> /dev/null && \
sudo apt -y install \
    terraform &>/dev/null || \
error "install terraform"
