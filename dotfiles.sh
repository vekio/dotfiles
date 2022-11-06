#!/usr/bin/env bash
#
# =============================================================================
#%SYNOPSIS
#+  ${SCRIPT_NAME} [OPTIONS] COMMAND
#%
#%DESCRIPTION
#%  Installs and config different setups
#%  If no command is given, install default setup
#%
#%COMMANDS
#%  default             install default setup
#%  wsl                 install wsl setup
#%  sdk                 install sdk setup
#%  devops              install devops setup
#%
#%OPTIONS
#%  -h, --help          display this help text and exit
#%  -V, --version       display version information and exit
#-
#-IMPLEMENTATION
#-  version             ${SCRIPT_NAME} ${VERSION}
#-  author              Alberto Castañeiras
# =============================================================================
set -e

# global variables
# -----------------------------------------------------------------------------
SCRIPT_NAME="$(basename ${0})"
VERSION="0.3.3"
DOTFILES_PATH="${HOME}/.dotfiles"

# packages
DEFAULT_PACKAGES=("git" "zsh")
SDK_PACKAGES=("${DEFAULT_PACKAGES[@]}" "build-essential" "neovim")
DEVOPS_PACKAGES=("${SDK_PACKAGES[@]}")
WSL_PACKAGES=("${DEVOPS_PACKAGES[@]}" "curl" "tree" "zip" "unzip")

SUDO=""; command -v sudo &>/dev/null && SUDO="sudo"

# flags
VERBOSE=false

# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
warn() { printf "%b[warn]%b %s\n" '\e[0;33m\033[1m' '\e[0m' "$*" >&2; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; }

# usage
# -----------------------------------------------------------------------------
function usage () {
    printf "Usage: "; head -30 ${0} | grep "^#+" | sed -e "s/^#+[ ]*//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g" -e "s/\${VERSION}/${VERSION}/g";
    printf "Try '%s --help' for more information\n" "${SCRIPT_NAME}";
}
function usagefull () {
    printf "Usage: "; head -30 ${0} | grep -e "^#[%+-]" | sed -e "s/^#[%+-]//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g" -e "s/\${VERSION}/${VERSION}/g";
}

#######################################
# Wrapper function that redirects the output of the command pass by argument.
# Globals:
#   VERBOSE
# Arguments:
#   A command to execute
# Returns:
#   0 if command executes, 1 on error
#######################################
function wrapper_redirect() {
    if [[ "${VERBOSE:-false}" == false ]]; then
        "$@" &> /dev/null && return 0 || return 1
    else
        "$@" && return 0 || return 1
    fi
}

#######################################
# Update package lists and install packages.
# Globals:
#   SUDO
# Arguments:
#   Array with the packages to install
#######################################
function install_packages () {
    local packages=("$@")
    info "installing packages $(echo ${packages[@]})"

    ${SUDO} apt update &>/dev/null || {
        error "update package list"
        exit 1
    }
    ${SUDO} apt install -y ${packages[@]} &>/dev/null || {
        error "install packages"
        exit 1
    }
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

    ${DOTFILES_PATH}/scripts/terraform.sh
}

# sdk setup
# -----------------------------------------------------------------------------
function sdk_setup () {
    default_setup

    bash ${DOTFILES_PATH}/scripts/nodejs.sh
    bash ${DOTFILES_PATH}/scripts/vim.sh
}

# default setup
# -----------------------------------------------------------------------------
function default_setup () {

    mkdir -p "${HOME}/.config" \
        "${HOME}/.cache" \
        "${HOME}/.local/bin" \
        "${HOME}/.local/share" \
        "${HOME}/.local/state" \
        "${HOME}/src"

    # clone dotfiles
    if [[ -d "${DOTFILES_PATH}" ]]; then
        cd ${DOTFILES_PATH} && git pull &> /dev/null || {
            error "update dotfiles"
            exit 1
        } && info "update dotfiles"
        cd - &> /dev/null
    else
        git clone https://github.com/vekio/dotfiles.git ${DOTFILES_PATH} &> /dev/null || {
            error "clone dotfiles"
            exit 1
        } && info "clone dotfiles"
    fi

    bash ${DOTFILES_PATH}/scripts/git.sh

    bash ${DOTFILES_PATH}/scripts/zsh.sh

    if [[ -z "${SUDO}" ]]; then
        chsh -s "$(command -v zsh)"
    else
        sudo -k chsh -s "$(command -v zsh)"
    fi
    # check if the shell change was successful
    if [[ "$?" -ne 0 ]]; then
        error "change your default shell manually, chsh -s "$(command -v zsh)""
    else
        export SHELL="$(command -v zsh)"
    fi
    echo &>/dev/null

    bash ${DOTFILES_PATH}/scripts/zsh-plugins.sh
    local bin="${HOME}/.local/bin"
    ln -fs "${DOTFILES_PATH}/scripts/zsh-plugins.sh" "${bin}/zsh-plugins"

    bash ${DOTFILES_PATH}/scripts/starship.sh
    bash ${DOTFILES_PATH}/scripts/fzf.sh
}


# main
# -----------------------------------------------------------------------------
function main () {
    # transform long options to short ones
    for ARG in "$@"; do
        shift
        case "${ARG}" in
            --help) set -- "$@" '-h' ;;
            --version) set -- "$@" '-V' ;;
            *) set -- "$@" "$ARG" ;;
        esac
    done

    # parse short options
    # adding : before the flags, I am telling getopts that I want to take control of flags that aren't in the list I set.
    while getopts ":hV" FLAG; do
        case "${FLAG}" in
            h) usagefull; exit ;;
            V) echo "${VERSION}"; exit ;;
            *) error "invalid option"; usage; exit 1 ;;
        esac
    done
    shift $((${OPTIND} -1))

    if [[ "$#" -eq 0 ]]; then
        info "choose default setup!"; install_packages ${DEFAULT_PACKAGES[@]}; default_setup
    elif [[ "$#" -gt 1 ]]; then
        error "too many arguments"; usage; exit 1
    else
        case "$*" in
            default) info "choose default setup!"; install_packages ${DEFAULT_PACKAGES[@]}; default_setup ;;
            wsl) info "choose wsl setup!"; install_packages ${WSL_PACKAGES[@]}; wsl_setup ;;
            sdk) info "choose sdl setup!"; install_packages ${SDK_PACKAGES[@]}; sdk_setup ;;
            devops) info "choose devops setup!"; install_packages ${DEVOPS_PACKAGES[@]}; devops_setup ;;
            *) error "unknow setup"; usage; exit 1 ;;
        esac
    fi

    # change to zsh shell
    exec zsh -l
}
main "$@"
