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
DOTFILES_PATH="${HOME}/.dotfiles"
SUDO="sudo"; [[ "${EUID}" -eq 0 ]] && SUDO=""
DEFAULT_PACKAGES=("git" "zsh")
SDK_PACKAGES=("${DEFAULT_PACKAGES[@]}" "build-essential" "neovim")
DEVOPS_PACKAGES=("${SDK_PACKAGES[@]}")
WSL_PACKAGES=("${DEVOPS_PACKAGES[@]}" "curl" "tree" "zip" "unzip")

# loggers
# -----------------------------------------------------------------------------
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
    if [[ -z "${1:-}" ]]; then
        usage
    else
        error "${1:-}"; usage
    fi
}

# install packages
# -----------------------------------------------------------------------------
function install_packages () {
    local packages=("$@")
    info "installing packages $(echo ${packages[@]})"

    ${SUDO} apt update # &> /dev/null || (error "update the package lists"; exit 1)
    ${SUDO} apt install -y ${packages[@]} # &> /dev/null
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
    bash ${DOTFILES_PATH}/installs/install-terraform.sh # &> /dev/null || error "terraform install"
}

# sdk setup
# -----------------------------------------------------------------------------
function sdk_setup () {
    default_setup

    # installs
    bash ${DOTFILES_PATH}/installs/install-nodejs.sh # &> /dev/null || error "nodejs install"

    # setups
    bash ${DOTFILES_PATH}/vim/setup.sh # &> /dev/null || error "vim setup"
}

# default setup
# -----------------------------------------------------------------------------
function default_setup () {

    # directories
    mkdir -p "${HOME}/.config" \
        "${HOME}/.cache" \
        "${HOME}/.local/bin" \
        "${HOME}/.local/share" \
        "${HOME}/.local/state" \
        "${HOME}/src/repos"

    # clone dotfiles
    if [[ -d "${DOTFILES_PATH}" ]]; then
        info "updating dotfiles"
        cd ${DOTFILES_PATH} && git pull # &> /dev/null
        cd - # &> /dev/null
    else
        info "cloning dotfiles"
        git clone -b feature/rewrite https://github.com/vekio/dotfiles.git ${DOTFILES_PATH} # &> /dev/null
    fi

    # installs
    bash ${DOTFILES_PATH}/installs/install-starship.sh # &> /dev/null || error "starship install"
    bash ${DOTFILES_PATH}/installs/install-fzf.sh # &> /dev/null || error "fzf install"

    # default setups
    bash ${DOTFILES_PATH}/zsh/setup.sh # &> /dev/null || error "zsh setup"
    bash ${DOTFILES_PATH}/git/setup.sh # &> /dev/null || error "git setup"
    bash ${DOTFILES_PATH}/starship/setup.sh # &> /dev/null || error "starship setup"
    bash ${DOTFILES_PATH}/fzf/setup.sh # &> /dev/null || error "fzf setup"

    # scripts
    local bin="${HOME}/.local/bin"
    ln -fs "${DOTFILES_PATH}/scripts/update-zsh-plugins" "${bin}/update-zsh-plugins"
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
        *) error_usage "invalid option"; exit 1 ;;
    esac
done
shift $((${OPTIND} -1))

if [[ "$#" -eq 0 ]]; then
    info "setting up default"; install_packages ${DEFAULT_PACKAGES[@]}; default_setup; exit
elif [[ "$#" -gt 1 ]]; then
    error_usage "too many arguments"; exit 1
fi

case "$*" in
    wsl) info "setting up wsl"; install_packages ${WSL_PACKAGES[@]}; wsl_setup; exit ;;
    sdk) info "setting up sdk"; install_packages ${SDK_PACKAGES[@]}; sdk_setup; exit ;;
    devops) info "setting up devops"; install_packages ${DEVOPS_PACKAGES[@]}; devops_setup; exit ;;
    *) error_usage "unknow setup"; exit 1 ;;
esac
