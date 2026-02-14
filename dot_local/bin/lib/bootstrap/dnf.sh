#!/usr/bin/env bash
set -euo pipefail

source "$DOTLIB/log.sh"

if ! command -v dnf >/dev/null 2>&1; then
  log_warn "dnf not found; skipping"
  exit 0
fi

BOOTSTRAP_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/bootstrap"
PKGS_FILE="$BOOTSTRAP_CONFIG_DIR/dnf.pkgs"
log_debug "dnf package file: $PKGS_FILE"

if [ ! -f "$PKGS_FILE" ]; then
  log_info "dnf package file not found ($PKGS_FILE); skipping"
  exit 0
fi

pkgs=()
while IFS= read -r line || [ -n "${line:-}" ]; do
  if [ -z "$line" ]; then
    continue
  fi
  case "$line" in
    \#*) continue ;;
  esac
  pkgs+=("$line")
done <"$PKGS_FILE"

if [ "${#pkgs[@]}" -eq 0 ]; then
  log_info "no dnf packages found in $PKGS_FILE; skipping"
  exit 0
fi

log_info "dnf installing packages: ${pkgs[*]}"
sudo dnf -y install "${pkgs[@]}"
