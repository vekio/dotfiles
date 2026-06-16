#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="${DOTFILES_SOURCE:-$(chezmoi source-path)}"
source "$ROOT/scripts/lib.sh"

title "Mise"

MISE_INSTALL_PATH="${MISE_INSTALL_PATH:-$HOME/.local/bin/mise}"
MISE_VERSION="${MISE_VERSION:-}"

ensure_dir "$(dirname "$MISE_INSTALL_PATH")"

if [ -x "$MISE_INSTALL_PATH" ]; then
  success "mise ya está instalado en $MISE_INSTALL_PATH"
  run "$MISE_INSTALL_PATH" --version
else
  info "Instalando mise con instalador oficial"

  if [ -n "$MISE_VERSION" ]; then
    info "Versión fijada: $MISE_VERSION"
    run env MISE_INSTALL_PATH="$MISE_INSTALL_PATH" MISE_VERSION="$MISE_VERSION" sh -c 'curl -fsSL https://mise.run | sh'
  else
    run env MISE_INSTALL_PATH="$MISE_INSTALL_PATH" sh -c 'curl -fsSL https://mise.run | sh'
  fi
fi

# Para que este mismo script pueda usar mise aunque la shell aún no haya recargado.
export PATH="$(dirname "$MISE_INSTALL_PATH"):$PATH"

if ! has mise; then
  fail "mise no está en PATH tras instalarlo"
fi

success "mise instalado"
run mise --version

if [ -f "$HOME/.config/mise/config.toml" ]; then
  info "Confiando configuración global de mise"
  run mise trust "$HOME/.config/mise/config.toml" || true

  info "Instalando herramientas definidas en ~/.config/mise/config.toml"
  run mise install
else
  warn "No existe ~/.config/mise/config.toml todavía. Ejecuta chezmoi apply antes de este script."
fi
