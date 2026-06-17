#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="${DOTFILES_SOURCE:-$(chezmoi source-path)}"
source "$ROOT/scripts/lib.sh"

title "Chezmoi apply"

info "Aplicando dotfiles desde $ROOT"
run chezmoi apply

success "Dotfiles aplicados"
