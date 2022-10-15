#!/usr/bin/env bash


# loggers
# -----------------------------------------------------------------------------
info() { printf "%b[info]%b %s\n"  '\e[0;32m\033[1m' '\e[0m' "$@" >&2; }
warn() { printf "%b[warn]%b %s\n"  '\e[0;33m\033[1m' '\e[0m' "$@" >&2; exit 0; }
error() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$@" >&2; exit 1; }


# source directory
# -----------------------------------------------------------------------------
SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) || error "source directory not found"


if [ -d "${HOME}/.local/share/miniconda3" ]; then
    info "update miniconda3"

    # update miniconda3
    # --------------------------------------------------------------------
    conda update --yes conda &>/dev/null
else
    info "setup miniconda3"

    # download miniconda3
    # -----------------------------------------------------------------------------
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda3.sh &>/dev/null || \
    error "download miniconda3"

    # install miniconda3
    # --------------------------------------------------------------------
    bash /tmp/miniconda3.sh -b -f -p "${HOME}/.local/share/miniconda3" &>/dev/null && \
    "${HOME}/.local/share/miniconda3/bin/conda" update --yes conda &>/dev/null && \
    "${HOME}/.local/share/miniconda3/bin/conda" config --set auto_activate_base false &>/dev/null && \
    "${HOME}/.local/share/miniconda3/bin/conda" init -d zsh &>/dev/null || \
    error "install miniconda3"

    rm /tmp/miniconda3.sh &>/dev/null
fi
