#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="${DOTFILES_SOURCE:-$(chezmoi source-path)}"
source "$ROOT/scripts/lib.sh"

require_fedora

title "Mise dev tools"

if ! has mise; then
  fail "mise no está instalado. Añádelo a packages/fedora/dnf.txt o instala mise antes."
fi

info "Trust de la configuración global de mise"
if [ -f "$HOME/.config/mise/config.toml" ]; then
  run mise trust "$HOME/.config/mise/config.toml" || true
fi

info "Instalando herramientas definidas en ~/.config/mise/config.toml"
run mise install

info "Comprobando Node"
run mise exec -- node --version

info "Comprobando pnpm"
run mise exec -- pnpm --version

info "Configurando PNPM_HOME"
PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
ensure_dir "$PNPM_HOME"
ensure_dir "$PNPM_HOME/bin"

export PNPM_HOME
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PNPM_HOME/bin:$PATH"

info "Instalando herramientas globales con pnpm"

run mise exec -- pnpm add -g @openai/codex

if [ -x "$PNPM_HOME/bin/codex" ]; then
  success "codex instalado en $PNPM_HOME/bin/codex"
  run "$PNPM_HOME/bin/codex" --version
elif command -v codex >/dev/null 2>&1; then
  run codex --version
else
  warn "codex instalado, pero no aparece en PATH. Abre una terminal nueva."
fi
