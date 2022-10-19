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
#%  wsl                 install wsl setup
#%  sdk                 install sdk setup
#%  devops              install devops setup
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
IS_SUDO=false; if [[ ${EUID} -eq 0 ]]; then IS_SUDO=true; fi
DOTFILES="${HOME}/.dotfiles"

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
    printf "Try '%s --help' for more information\n" "${SCRIPT_NAME}";
}
function usagefull () {
    printf "Usage: "; head -30 ${0} | grep -e "^#[%+-]" | sed -e "s/^#[%+-]//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g";
}
function error_usage () {
    if [[ -z "${1-}" ]]; then
        usage; exit 1;
    else
        error "${1-}"; usage; exit 1;
    fi
}

# install packages
# -----------------------------------------------------------------------------
DEFAULT_PACKAGES=("git" "zsh")
SDK_PACKAGES=("build-essential"); SDK_PACKAGES+=(${DEFAULT_PACKAGES[@]})
DEVOPS_PACKAGES=(); DEVOPS_PACKAGES+=("${SDK_PACKAGES[@]}")
WSL_PACKAGES=("curl" "tree" "zip" "unzip"); WSL_PACKAGES+=(${DEVOPS_PACKAGES[@]})
function install_packages () {
    if ${IS_SUDO}; then
        apt update &> /dev/null || (error "update the package lists"; exit 1)
        apt install -y ${1} &> /dev/null
    else
        sudo apt update &> /dev/null || (error "update the package lists"; exit 1)
        sudo apt install -y ${1}  &> /dev/null
    fi
}

# wsl setup
# -----------------------------------------------------------------------------
function wsl_setup () {
    devops_setup
}

# devops setup
# -----------------------------------------------------------------------------
function devops_setup () {
    sdk_setup

    # installs
    bash ${DOTFILES}/installs/install-terraform.sh
}

# sdk setup
# -----------------------------------------------------------------------------
function sdk_setup () {
    default_setup

    # installs
    bash ${DOTFILES}/installs/install-nodejs.sh
}

# default setup
# -----------------------------------------------------------------------------
function default_setup () {
    # clone dotfiles
    [[ -d "$dotfiles" ]] && (error "$dotfiles folder exists, remove it"; exit 1)
    info "cloning dotfiles"
    git clone -b feature/new-setup https://gitea.casta.me/alberto/dotfiles.git ${DOTFILES} &> /dev/null

    # setups
    bash ${DOTFILES}/zsh/setup.sh
    bash ${DOTFILES}/git/setup.sh
}

# main
# -----------------------------------------------------------------------------
# transform long options to short ones
for ARG in "$@"; do
  shift
  case "${ARG}" in
    --help) set -- "$@" '-h' ;;
    --version) set -- "$@" '-v' ;;
    *) set -- "$@" "$ARG" ;;
  esac
done

# parse short options
# adding : before the flags, I am telling getopts that I want to take control of flags that aren't in the list I set.
while getopts ":vh" FLAG; do
    case "${FLAG}" in
        h) usagefull; exit ;;
        v) echo "version"; exit ;;
        *) error_usage "invalid option" ;;
    esac
done
shift $((${OPTIND} -1))

if [[ "$#" -eq 0 ]]; then
    error_usage "expected at least one setup"
elif [[ "$#" -gt 1 ]]; then
    error_usage "too many arguments"
fi

case "$*" in
    wsl) info "setting up wsl"; install_packages ${WSL_PACKAGES[@]}; wsl_setup; exit ;;
    sdk) info "setting up sdk"; install_packages ${SDK_PACKAGES[@]}; sdk_setup; exit ;;
    devops) info "setting up devops"; install_packages ${DEVOPS_PACKAGES[@]}; devops_setup; exit ;;
    *) error_usage "$* is not a valid setup" ;;
esac
