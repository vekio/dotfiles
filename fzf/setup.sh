#!/usr/bin/env bash
#
# Config fzf.
set -euo pipefail
IFS=$'\n\t'

# source directory
# -----------------------------------------------------------------------------
SRCDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# create fzf symlinks
# -----------------------------------------------------------------------------
ln -sf "${SRCDIR}/fzf" "${HOME}/.config/zsh/.fzf"
