#!/usr/bin/env bash
set -euo pipefail

brew_bundle_file="$HOME/.config/bootstrap/brewfile"

if command -v brew >/dev/null 2>&1; then
  if [ -f "$brew_bundle_file" ]; then
    log_info "Installing brew packages from: $brew_bundle_file"
    brew bundle --file "$brew_bundle_file"
  else
    log_warn "No Brewfile found at: $brew_bundle_file"
  fi
else
  log_warn "brew not found; skipping brew package install."
fi
