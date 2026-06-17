#!/usr/bin/env bash

# Shared installer library loader. Keep the modules small and boring.

set -Eeuo pipefail

DOTFILES_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/lib" && pwd)"

source "$DOTFILES_LIB_DIR/core.sh"
source "$DOTFILES_LIB_DIR/log.sh"
source "$DOTFILES_LIB_DIR/error.sh"
source "$DOTFILES_LIB_DIR/run.sh"
