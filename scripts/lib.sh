#!/usr/bin/env bash

set -Eeuo pipefail

DOTFILES_SOURCE="${DOTFILES_SOURCE:-$(chezmoi source-path 2>/dev/null || pwd)}"
DOTFILES_NONINTERACTIVE="${DOTFILES_NONINTERACTIVE:-0}"
DOTFILES_YES="${DOTFILES_YES:-0}"

has() {
  command -v "$1" >/dev/null 2>&1
}

is_interactive() {
  [ "$DOTFILES_NONINTERACTIVE" != "1" ] && [ -t 0 ]
}

title() {
  if has gum; then
    gum style \
      --border normal \
      --padding "0 1" \
      --margin "1 0" \
      --bold \
      "$*"
  else
    printf "\n== %s ==\n" "$*"
  fi
}

info() {
  if has gum; then
    gum style --foreground 39 "==> $*"
  else
    printf "\n==> %s\n" "$*"
  fi
}

success() {
  if has gum; then
    gum style --foreground 46 "OK  $*"
  else
    printf "OK  %s\n" "$*"
  fi
}

warn() {
  if has gum; then
    gum style --foreground 214 "WARN  $*" >&2
  else
    printf "WARN  %s\n" "$*" >&2
  fi
}

fail() {
  if has gum; then
    gum style --foreground 196 --bold "ERROR  $*" >&2
  else
    printf "ERROR  %s\n" "$*" >&2
  fi
  exit 1
}

run() {
  printf "+ "
  printf "%q " "$@"
  printf "\n"
  "$@"
}

run_script() {
  local script="$1"

  [ -f "$script" ] || fail "No existe script: $script"

  title "Ejecutando $(basename "$script")"
  chmod +x "$script"
  "$script"
}

confirm() {
  local question="$1"
  local default="${2:-no}"

  if [ "$DOTFILES_YES" = "1" ]; then
    return 0
  fi

  if ! is_interactive; then
    [ "$default" = "yes" ]
    return $?
  fi

  if has gum; then
    if [ "$default" = "yes" ]; then
      gum confirm --default=true "$question"
    else
      gum confirm "$question"
    fi
  else
    local answer
    read -r -p "$question [y/N]: " answer
    case "$answer" in
      y|Y|yes|YES) return 0 ;;
      *) return 1 ;;
    esac
  fi
}

prompt_input() {
  local prompt="$1"
  local default="${2:-}"

  if ! is_interactive; then
    printf "%s" "$default"
    return
  fi

  if has gum; then
    gum input --prompt "$prompt " --value "$default"
  else
    local answer
    read -r -p "$prompt " answer
    printf "%s" "${answer:-$default}"
  fi
}

os_id() {
  . /etc/os-release
  echo "${ID:-unknown}"
}

require_fedora() {
  [ "$(os_id)" = "fedora" ] || fail "Este script está preparado para Fedora. Detectado: $(os_id)"
}

read_package_file() {
  local file="$1"

  [ -f "$file" ] || fail "No existe fichero de paquetes: $file"

  grep -Ev '^\s*(#|$)' "$file" | sed 's/#.*//' | awk '{$1=$1};1'
}

dnf_install_packages_from_file() {
  local file="$1"
  mapfile -t packages < <(read_package_file "$file")

  if [ "${#packages[@]}" -eq 0 ]; then
    warn "No hay paquetes en $file"
    return
  fi

  run sudo dnf install -y "${packages[@]}"
}

dnf_install_if_available() {
  local available=()
  local pkg

  for pkg in "$@"; do
    if dnf -q info "$pkg" >/dev/null 2>&1; then
      available+=("$pkg")
    else
      warn "Paquete no disponible en repos actuales: $pkg"
    fi
  done

  if [ "${#available[@]}" -gt 0 ]; then
    run sudo dnf install -y "${available[@]}"
  fi
}

ensure_dir() {
  local dir="$1"
  local mode="${2:-755}"

  install -d -m "$mode" "$dir"
}

append_line_if_missing() {
  local file="$1"
  local line="$2"

  touch "$file"

  if ! grep -Fxq "$line" "$file"; then
    printf "%s\n" "$line" >> "$file"
  fi
}

write_file() {
  local file="$1"
  local mode="${2:-644}"

  ensure_dir "$(dirname "$file")"
  cat > "$file"
  chmod "$mode" "$file"
}
