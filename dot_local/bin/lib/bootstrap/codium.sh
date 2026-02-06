#!/usr/bin/env bash
set -euo pipefail

code_cmd=""
if command -v code >/dev/null 2>&1; then
  code_cmd="code"
elif command -v codium >/dev/null 2>&1; then
  code_cmd="codium"
elif command -v flatpak >/dev/null 2>&1; then
  code_cmd="flatpak run com.vscodium.codium"
elif command -v flatpak-spawn >/dev/null 2>&1; then
  code_cmd="flatpak-spawn --host flatpak run com.vscodium.codium"
fi

if [ -n "$code_cmd" ]; then
  if ! $code_cmd --list-extensions | grep -qx 'zokugun.vsix-manager'; then
    log_info "Installing VSCodium extension: zokugun.vsix-manager"
    $code_cmd --install-extension zokugun.vsix-manager
  else
    log_info "VSCodium extension already installed: zokugun.vsix-manager"
  fi
else
  log_warn "code/codium not found; skipping VSCodium extension install."
fi
