#!/usr/bin/env bash

# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n"  '\e[0;32m\033[1m' '\e[0m' "$@" >&2; }
warn() { printf "%b[warn]%b %s\n"  '\e[0;33m\033[1m' '\e[0m' "$@" >&2; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$@" >&2; exit 1; }


# home setup
# -----------------------------------------------------------------------------
function home_setup () {
    info "home setup"

    packages="git build-essential"
    info "install packages: ${packages}"

    sudo apt update && \
    sudo apt install -y \
        ${packages}

}


# setup menu
# -----------------------------------------------------------------------------
PS3='Choose your setup to install: '
setups=("home" "quit")

select setup in "${setups[@]}"; do
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
