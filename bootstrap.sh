#!/usr/bin/env bash
set -Eeuo pipefail

DOTFILES_REPO="${DOTFILES_REPO:-https://git.casta.me/alberto/dotfiles_new.git}"
DOTFILES_BRANCH="${DOTFILES_BRANCH:-main}"

export PATH="$HOME/.local/bin:$PATH"

log() {
  printf "\n\033[1;34m==>\033[0m %s\n" "$*"
}

die() {
  echo "ERROR: $*" >&2
  exit 1
}

has() {
  command -v "$1" >/dev/null 2>&1
}

detect_os() {
  [ -f /etc/os-release ] || die "No existe /etc/os-release"
  . /etc/os-release
  echo "${ID:-unknown}"
}

install_base_fedora() {
  log "Instalando herramientas base en Fedora"

  sudo dnf install -y \
    git \
    curl \
    ca-certificates \
    openssh-clients \
    gum \
    chezmoi
}

install_base_tools() {
  local os
  os="$(detect_os)"

  case "$os" in
    fedora)
      install_base_fedora
      ;;
    *)
      die "Por ahora este bootstrap está preparado para Fedora. Detectado: $os"
      ;;
  esac
}

main() {
  install_base_tools

  log "Inicializando dotfiles desde $DOTFILES_REPO"
  chezmoi init --apply --branch "$DOTFILES_BRANCH" "$DOTFILES_REPO"

  log "Ejecutando install.sh del repo"
  "$(chezmoi source-path)/install.sh"

  log "Bootstrap completado"
}

main "$@"
