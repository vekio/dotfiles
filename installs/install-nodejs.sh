#!/usr/bin/env bash
#
# Install nvm and nodejs.
set -euo pipefail
IFS=$'\n\t'

# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
warn() { printf "%b[warn]%b %s\n" '\e[0;33m\033[1m' '\e[0m' "$*" >&2; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; }

# install nvm
# -----------------------------------------------------------------------------
NVM_VERSION="v0.39.2"
if ! command -v nvm &>/dev/null; then
    info "install nvm"
    curl -o- -s https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash &>/dev/null
fi

# load nvm
NVM_DIR="$([[ -z "${XDG_CONFIG_HOME-}" ]] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[[ -s "${NVM_DIR}/nvm.sh" ]] && \. "${NVM_DIR}/nvm.sh"

# install nodejs
# -----------------------------------------------------------------------------
if ! command -v node &>/dev/null; then
    info "install nodejs"
    nvm install --lts &>/dev/null
fi
