#!/usr/bin/env bash


# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n"  '\e[0;32m\033[1m' '\e[0m' "$@" >&2; }
warn() { printf "%b[warn]%b %s\n"  '\e[0;33m\033[1m' '\e[0m' "$@" >&2; exit 0; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$@" >&2; exit 1; }


# source directory
# -----------------------------------------------------------------------------
SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) || error "source directory not found"


if [ -d "${HOME}/.local/share/fzf" ]; then
    info "update fzf"

    # update fzf
    # -----------------------------------------------------------------------------
    cd "${HOME}/.local/share/fzf" && git pull &>/dev/null &&
    yes | "${HOME}/.local/share/fzf/install" --bin --no-update-rc &>/dev/null || \
    error "update fzf"
else
    info "setup fzf"

    # install fzf
    # -----------------------------------------------------------------------------
    git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.local/share/fzf" &>/dev/null && \
    yes | "${HOME}/.local/share/fzf/install" --bin --no-update-rc &>/dev/null || \
    error "install fzf"


    # create fzf symlinks
    # -----------------------------------------------------------------------------
    ln -sf "${SDIR}/config" "${HOME}/.config/zsh/.fzf" || \
    error "create fzf symlinks"
fi
