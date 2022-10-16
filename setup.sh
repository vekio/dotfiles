#!/usr/bin/env bash
#
#
set -euo pipefail
IFS=$'\n\t'

SETUP=${1:"nada"}
echo ${SETUP}

# loggers
# -----------------------------------------------------------------------------
info() { printf "$(date +%FT%T) %b[info]%b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
warn() { printf "$(date +%FT%T) %b[warn]%b %s\n" '\e[0;33m\033[1m' '\e[0m' "$*" >&2; }
erro() { printf "$(date +%FT%T) %b[erro]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; exit 1; }

# usage
# -----------------------------------------------------------------------------
# function usage () {
# }

# home setup
# -----------------------------------------------------------------------------
function home_setup () {
    info "home setup"

    packages="curl git zsh build-essential tree zip unzip"
    info "install packages: ${packages}"

    if ${IS_SUDO}; then
        apt update && \
        apt install -y \
            ${packages}
    else
        sudo apt update && \
        sudo apt install -y \
            ${packages}
    fi

    # clone dotfiles
    DOTFILES="${HOME}/.dotfiles"
    git clone https://gitea.casta.me/alberto/dotfiles.git ${DOTFILES}

    # setups
    bash ${DOTFILES}/zsh/setup.sh
}

IS_SUDO=false
if [[ "${EUID}" -eq 0 ]]; then
  IS_SUDO=true
fi

# setup menu
# -----------------------------------------------------------------------------
PS3='Choose your setup to install: '
SETUPS=("home" "quit")

select setup in "${SETUPS[@]}"; do
    case ${setup} in
        "home")
            home_setup
            break
            ;;
        "quit")
            info "Bye!"
            exit
            ;;
        *) echo warn "invalid option ${REPLY}";;
    esac
done
