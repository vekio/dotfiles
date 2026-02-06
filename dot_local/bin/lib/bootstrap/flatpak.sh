#!/usr/bin/env bash
set -euo pipefail

flatpak_pkg_file="$HOME/.config/bootstrap/flatpak.pkgs"

flatpak_cmd=""
if command -v flatpak >/dev/null 2>&1; then
  flatpak_cmd="flatpak"
elif command -v flatpak-spawn >/dev/null 2>&1; then
  flatpak_cmd="flatpak-spawn --host flatpak"
fi

if [ -n "$flatpak_cmd" ]; then
  log_info "Ensuring Flathub remote is present and enabled."
  $flatpak_cmd remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo >/dev/null 2>&1 || true
  $flatpak_cmd remote-modify --enable flathub >/dev/null 2>&1 || true

  if [ -f "$flatpak_pkg_file" ]; then
    log_info "Installing flatpak packages from: $flatpak_pkg_file"
    while IFS= read -r app; do
      case "$app" in
        ""|\#*) continue ;;
        *)
          if $flatpak_cmd info --show-origin "$app" >/dev/null 2>&1; then
            origin="$($flatpak_cmd info --show-origin "$app" 2>/dev/null || true)"
            if [ "$origin" != "flathub" ] && [ -n "$origin" ]; then
              log_warn "$app already installed from remote '$origin'; skipping flathub install."
              continue
            fi
          fi
          $flatpak_cmd install -y flathub "$app"
          ;;
      esac
    done < "$flatpak_pkg_file"
  else
    log_warn "No flatpak package list found at: $flatpak_pkg_file"
  fi
else
  log_warn "flatpak not found; skipping flatpak package install."
fi
