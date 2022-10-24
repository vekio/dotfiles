#!/usr/bin/env bash
#
# Setup starship.
set -euo pipefail
IFS=$'\n\t'

# source directory
# -----------------------------------------------------------------------------
SRCDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# create starship symlinks
# -----------------------------------------------------------------------------
ln -sf "${SRCDIR}/starship.toml" "${HOME}/.config/starship.toml"
