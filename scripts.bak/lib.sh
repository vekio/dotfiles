#!/usr/bin/env bash
set -Eeuo pipefail

DOTFILES_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/lib" && pwd)"

source "$DOTFILES_LIB_DIR/core.sh"
source "$DOTFILES_LIB_DIR/log.sh"
source "$DOTFILES_LIB_DIR/error.sh"
source "$DOTFILES_LIB_DIR/run.sh"
source "$DOTFILES_LIB_DIR/prompt.sh"
source "$DOTFILES_LIB_DIR/platform.sh"
source "$DOTFILES_LIB_DIR/packages.sh"
source "$DOTFILES_LIB_DIR/fs.sh"
