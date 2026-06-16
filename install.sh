#!/usr/bin/env bash
set -Eeuo pipefail

if ! command -v chezmoi >/dev/null 2>&1; then
  echo "ERROR: chezmoi no está instalado" >&2
  exit 1
fi

ROOT="$(chezmoi source-path)"

export DOTFILES_SOURCE="$ROOT"

source "$ROOT/scripts/lib.sh"

title "Dotfiles install"
info "Source: $ROOT"

run_script "$ROOT/scripts/05-fedora-repos.sh"
run_script "$ROOT/scripts/10-dnf-apps.sh"
run_script "$ROOT/scripts/17-mise.sh"
run_script "$ROOT/scripts/18-mise-tools.sh"

success "Instalación terminada"
