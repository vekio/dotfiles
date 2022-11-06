#!/usr/bin/env bash
#
# Script to install or update zsh plugins.
set -euo pipefail
IFS=$'\n\t'

# global variables
# -----------------------------------------------------------------------------
SCRIPT_NAME="$(basename ${0})"
XDG_DATA_HOME="${XDG_DATA_HOME:-"${HOME}/.local/share"}"

# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
warn() { printf "%b[warn]%b %s\n" '\e[0;33m\033[1m' '\e[0m' "$*" >&2; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; }

#######################################
# Install or update zsh plugin git.
# Globals:
#   XDG_DATA_HOME
# Arguments:
#   Plugin github repo
#######################################
function install_update_zsh_plugins () {
    local repo_path="${1}"
    local project="$(echo "${repo_path}" | cut -d"/" -f2)"
    local project_path="${XDG_DATA_HOME}/${project}"

    if cd "${project_path}" > /dev/null 2>&1; then
        git pull &> /dev/null || {
            error "update ${repo_path}"
            exit 1
        } && info "update ${repo_path}"
        cd - > /dev/null 2>&1
    else
        git clone "https://github.com/${repo_path}" "${project_path}" &> /dev/null || {
            error "install ${repo_path}"
            exit 1
        } && info "install ${repo_path}"
    fi
}

# main
# -----------------------------------------------------------------------------
function main () {
    # install_update_zsh_plugins "zdharma/fast-syntax-highlighting"
    install_update_zsh_plugins "zsh-users/zsh-autosuggestions"
}
main "$@"
