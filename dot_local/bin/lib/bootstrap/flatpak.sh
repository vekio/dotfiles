#!/usr/bin/env bash
set -euo pipefail

source "$DOTLIB/log.sh"

BOOTSTRAP_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/bootstrap"
PKGS_FILE="$BOOTSTRAP_CONFIG_DIR/flatpak.pkgs"
log_debug "flatpak package file: $PKGS_FILE"

flatpak_cmd=()
if command -v flatpak >/dev/null 2>&1; then
  flatpak_cmd=(flatpak)
elif command -v flatpak-spawn >/dev/null 2>&1; then
  flatpak_cmd=(flatpak-spawn --host flatpak)
fi

if [ "${#flatpak_cmd[@]}" -gt 0 ]; then
  log_info "ensuring flathub remote is present and enabled"
  "${flatpak_cmd[@]}" remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo >/dev/null 2>&1 || true
  "${flatpak_cmd[@]}" remote-modify --enable flathub >/dev/null 2>&1 || true

  if [ -f "$PKGS_FILE" ]; then
    log_info "installing flatpak packages from: $PKGS_FILE"

    # Cache installed apps once (avoid calling `flatpak info` for everything).
    declare -A installed_apps=()
    if installed_list="$("${flatpak_cmd[@]}" list --app --columns=application 2>/dev/null)"; then
      while IFS= read -r app || [ -n "${app:-}" ]; do
        [ -n "$app" ] && installed_apps["$app"]=1
      done <<<"$installed_list"
      log_debug "flatpak installed apps: ${#installed_apps[@]}"
    else
      log_warn "flatpak list failed; will attempt installs without checking installed set"
    fi

    while IFS= read -r app || [ -n "${app:-}" ]; do
      case "$app" in
        ''|\#*) continue ;;
      esac

      if [ -n "${installed_apps["$app"]+x}" ]; then
        origin="$("${flatpak_cmd[@]}" info --show-origin "$app" 2>/dev/null || true)"
        if [ -n "$origin" ] && [ "$origin" != "flathub" ]; then
          log_warn "$app already installed from remote '$origin'; skipping flathub install"
          continue
        fi
        log_debug "$app already installed"
        continue
      fi

      "${flatpak_cmd[@]}" install -y flathub "$app"
    done <"$PKGS_FILE"
  else
    log_info "flatpak package file not found ($PKGS_FILE); skipping"
  fi
else
  log_warn "flatpak not found; skipping flatpak package install."
fi

log_info "flatpak bootstrap finished ok"
