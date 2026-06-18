#!/usr/bin/env bash
#
# Install mise and the development tools declared in ~/.config/mise/config.toml.
# This script also installs global pnpm tools that are part of the workstation.

set -Eeuo pipefail

SCRIPTS="${DOTFILES_SCRIPTS:-$HOME/.local/share/dotfiles/scripts}"
source "$SCRIPTS/lib.sh"

MISE_INSTALL_PATH="${MISE_INSTALL_PATH:-$HOME/.local/bin/mise}"
MISE_CONFIG="${MISE_CONFIG:-$HOME/.config/mise/config.toml}"
MISE_VERSION="${MISE_VERSION:-}"
PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"

install_mise() {
  if has mise; then
    detail "mise already installed"
    return
  fi

  detail "Installing mise"
  mkdir -p "$(dirname "$MISE_INSTALL_PATH")"

  if [ -n "$MISE_VERSION" ]; then
    run env MISE_INSTALL_PATH="$MISE_INSTALL_PATH" MISE_VERSION="$MISE_VERSION" sh -c 'curl -fsSL https://mise.run | sh'
  else
    run env MISE_INSTALL_PATH="$MISE_INSTALL_PATH" sh -c 'curl -fsSL https://mise.run | sh'
  fi
}

load_mise_for_script() {
  # Make mise available before the shell reloads PATH.
  export PATH="$(dirname "$MISE_INSTALL_PATH"):$PATH"

  has mise || fail "mise is not available after installation"
  detail "mise: $(mise --version)"
}

install_mise_tools() {
  if [ ! -f "$MISE_CONFIG" ]; then
    warn "Missing mise config: $MISE_CONFIG"
    return
  fi

  detail "Trusting mise config"
  run mise trust "$MISE_CONFIG"

  detail "Installing mise tools"
  run mise install

  detail "node: $(mise exec -- node --version)"
  detail "pnpm: $(mise exec -- pnpm --version)"
}

configure_pnpm() {
  # Keep pnpm global binaries in PNPM_HOME, which is exported by fish config.
  mkdir -p "$PNPM_HOME"

  export PNPM_HOME
  export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PNPM_HOME:$PATH"

  detail "Configuring pnpm global bin dir"
  run mise exec -- pnpm config set global-bin-dir "$PNPM_HOME"
}

install_global_pnpm_tools() {
  detail "Installing global pnpm tools"
  run mise exec -- pnpm add -g @openai/codex

  if has codex; then
    detail "codex: $(codex --version)"
  else
    warn "codex installed, but it is not available in PATH yet. Open a new shell."
  fi
}

title "Mise tools"

install_mise
load_mise_for_script
install_mise_tools
configure_pnpm
install_global_pnpm_tools

success "Mise tools installed"
