#!/usr/bin/env bash
set -euo pipefail

. "$DOTLIB/log.sh"
LOG_LEVEL="debug"

if ! command -v codium >/dev/null 2>&1; then
  log_warn "codium not found; skipping extension install"
  exit 0
fi

BOOTSTRAP_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/bootstrap"
PKGS="$BOOTSTRAP_CONFIG_DIR/codium.extensions"
log_debug "codium extensions file: $PKGS"
if [ ! -f "$PKGS" ]; then
  log_debug "codium extensions file not found ($PKGS); skipping"
  exit 0
fi

# Read desired extensions from file.
# Rules:
# - ignore empty lines
# - ignore lines starting with '#'
desired_extensions=()
while IFS= read -r line || [ -n "${line:-}" ]; do
  if [ -z "$line" ]; then
    continue
  fi
  case "$line" in
    \#*) continue ;;
  esac
  desired_extensions+=("$line")
done <"$PKGS"

if [ "${#desired_extensions[@]}" -eq 0 ]; then
  log_info "no desired extensions found in $PKGS; skipping"
  exit 0
fi
log_debug "desired extensions: ${#desired_extensions[@]}"

# Get installed extensions (fetch once).
declare -A installed_extensions=()
if ! installed="$(codium --list-extensions 2>/dev/null)"; then
  log_warn "codium --list-extensions failed; treating as none installed"
  installed=""
fi
while IFS= read -r ext || [ -n "${ext:-}" ]; do
  if [ -n "$ext" ]; then
    installed_extensions["$ext"]=1
  fi
done <<<"$installed"
log_debug "installed extensions: ${#installed_extensions[@]}"

# Build a desired set for fast membership tests.
declare -A desired_set=()
for ext in "${desired_extensions[@]}"; do
  desired_set["$ext"]=1
done

# Figure out what needs to be installed.
install_args=()
to_install=()
for ext in "${desired_extensions[@]}"; do
  if [ -n "${installed_extensions["$ext"]+x}" ]; then
    log_debug "already installed: $ext"
    continue
  fi
  to_install+=("$ext")
  install_args+=("--install-extension" "$ext")
done

if [ "${#to_install[@]}" -eq 0 ]; then
  log_info "codium extensions already up to date"
else
  log_info "codium installing extensions: ${to_install[*]}"
  codium "${install_args[@]}" >/dev/null 2>&1 || true
fi

# Uninstall extensions that are installed but not present in codium.extensions.
# Only do this if we successfully captured a list of installed extensions.
if [ -z "$installed" ]; then
  log_warn "skipping uninstall step because installed extension list is empty/unavailable"
  exit 0
fi

uninstall_args=()
to_uninstall=()
for ext in "${!installed_extensions[@]}"; do
  if [ -z "${desired_set["$ext"]+x}" ]; then
    to_uninstall+=("$ext")
    uninstall_args+=("--uninstall-extension" "$ext")
  fi
done

if [ "${#to_uninstall[@]}" -eq 0 ]; then
  log_debug "no extra extensions to uninstall"
  exit 0
fi

log_info "codium uninstalling extensions (not in $PKGS): ${to_uninstall[*]}"
codium "${uninstall_args[@]}" >/dev/null 2>&1 || true
