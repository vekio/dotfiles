#!/usr/bin/env bash
#
# Config zsh.
set -euo pipefail
IFS=$'\n\t'

# source directory
# -----------------------------------------------------------------------------
SRCDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# check zsh
# -----------------------------------------------------------------------------
if ! command -v zsh &>/dev/null; then
    exit 1
fi

# create zsh directories
# -----------------------------------------------------------------------------
mkdir -p "${HOME}/.config/zsh" \
    "${HOME}/.cache/zsh"

# create zsh symlinks
# -----------------------------------------------------------------------------
ln -fs "${SRCDIR}/zshenv" "${HOME}/.zshenv"
ln -fs "${SRCDIR}/zshrc" "${HOME}/.config/zsh/.zshrc"
ln -fs "${SRCDIR}/aliases" "${HOME}/.config/zsh/.aliases"
ln -fs "${SRCDIR}/helpers" "${HOME}/.config/zsh/.helpers"

# plugins
# -----------------------------------------------------------------------------
bash ${SRCDIR}/../scripts/update-zsh-plugins

# change to zsh
# -----------------------------------------------------------------------------
chsh -s "$(command -v zsh)"
# exec bash -l
