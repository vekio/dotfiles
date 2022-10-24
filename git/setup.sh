#!/usr/bin/env bash
#
# Config git.
set -euo pipefail
IFS=$'\n\t'

# check git
# -----------------------------------------------------------------------------
if ! command -v git &>/dev/null; then
    exit 1
fi

# git config
# -----------------------------------------------------------------------------
git config --global user.name "Alberto Castañeiras"
git config --global user.email "alberto@casta.me"

# git config --global includeIf."gitdir:~/mz/".path ~/mz/.gitconfig
