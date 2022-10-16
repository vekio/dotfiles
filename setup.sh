#!/usr/bin/env bash
#
# =============================================================================
#%SYNOPSIS
#+  ${SCRIPT_NAME} [OPTIONS] SETUP
#%
#%DESCRIPTION
#%  Installs and config different setups
#%
#%SETUPS
#%  home                install home setup
#%
#%OPTIONS
#%  -v, --version       display version information and exit
#%  -h, --help          display this help text and exit
#-
#-IMPLEMENTATION
#-  version             ${SCRIPT_NAME} alpha
#-  author              Alberto Castañeiras
# =============================================================================
set -euo pipefail
IFS=$'\n\t'

# global variables
# -----------------------------------------------------------------------------
unset SCRIPT_NAME
SCRIPT_NAME="$(basename ${0})"
IS_SUDO=false; if [[ "${EUID}" -eq 0 ]]; then IS_SUDO=true; fi

# loggers
# -----------------------------------------------------------------------------
# info() { printf "$(date +%FT%T) %b[info]%b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
# warn() { printf "$(date +%FT%T) %b[warn]%b %s\n" '\e[0;33m\033[1m' '\e[0m' "$*" >&2; }
# error() { printf "$(date +%FT%T) %b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; exit 1; }
info() { printf "%b[info]%b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
warn() { printf "%b[warn]%b %s\n" '\e[0;33m\033[1m' '\e[0m' "$*" >&2; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; }

# usage
# -----------------------------------------------------------------------------
function usage () {
    printf "Usage: "; head -30 ${0} | grep "^#+" | sed -e "s/^#+[ ]*//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g";
    printf "Try '%s --help' for more information\n" "$SCRIPT_NAME";
}
function usagefull () {
    printf "Usage: "; head -30 ${0} | grep -e "^#[%+-]" | sed -e "s/^#[%+-]//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g";
}
function error_usage () {
    error "${1:-""}"; usage; exit 1;
}

function install_packages () {
    sudo apt update &> /dev/null || (error "update the package lists"; exit 1)
    echo $@
    echo $#
    for package in "$@"; do
        echo $package
        if $IS_SUDO; then
            apt install -y "$package" &> /dev/null || warn "unenable to install $package" && info "install $package"
        else
            sudo apt install -y "$package" &> /dev/null || warn "unenable to install $package" && info "install $package"
        fi
    done
}

# home setup
# -----------------------------------------------------------------------------
function home_setup () {
    info "home setup"

    packages=("curl" "git" "zsh" "build-essential" "tree" "zip" "unzip")
    # packages="curl git zsh build-essential tree zip unzip"
    # info "install packages: $packages"
    apt install -y ${packages[@]}
    # install_packages ${packages[@]}

    # clone dotfiles
    dotfiles="${HOME}/.dotfiles"
    [[ -d "$dotfiles" ]] && (error "$dotfiles folder exists, remove it"; exit 1)
    # || (error "$dotfiles folder exists, remove it"; exit 1)
    # git clone https://gitea.casta.me/alberto/dotfiles.git $dotfiles

    # setups
    # bash ${DOTFILES}/zsh/setup.sh
}

# main
# -----------------------------------------------------------------------------
# transform long options to short ones
for ARG in "$@"; do
  shift
  case "$ARG" in
    --help) set -- "$@" '-h' ;;
    --version) set -- "$@" '-v' ;;
    *) set -- "$@" "$ARG" ;;
  esac
done

# parse short options
# adding : before the flags, I am telling getopts that I want to take control of flags that aren't in the list I set.
while getopts ":vh" FLAG; do
    case "$FLAG" in
        h) usagefull; exit ;;
        v) echo "version"; exit ;;
        *) error_usage "invalid option";;
    esac
done
shift $(($OPTIND -1))

if [[ "$#" -eq 0 ]]; then
    error_usage "expected at least one setup"
elif [[ "$#" -gt 1 ]]; then
    error_usage "too many arguments"
fi

SETUP="$*"
case "$SETUP" in
    home) home_setup; exit ;;
    *) error_usage "$SETUP is not a valid setup";;
esac
