#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="${DOTFILES_SOURCE:-$(chezmoi source-path)}"
source "$ROOT/scripts/lib.sh"

require_fedora

title "Fedora third-party repositories"

FEDORA_VERSION="$(rpm -E %fedora)"

enable_rpmfusion() {
  title "RPM Fusion"

  if rpm -q rpmfusion-free-release >/dev/null 2>&1 && \
     rpm -q rpmfusion-nonfree-release >/dev/null 2>&1; then
    success "RPM Fusion free/nonfree ya está instalado"
    return
  fi

  info "Instalando RPM Fusion free/nonfree para Fedora $FEDORA_VERSION"

  run sudo dnf install -y \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm"
}

enable_terra() {
  title "Terra"

  if rpm -q terra-release >/dev/null 2>&1; then
    success "Terra ya está instalado"
    return
  fi

  info "Instalando Terra"

  run sudo dnf install -y \
    --nogpgcheck \
    --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' \
    terra-release
}

enable_brave_repo() {
  title "Brave repository"

  if [ -f /etc/yum.repos.d/brave-browser.repo ]; then
    success "Repo de Brave ya está configurado"
    return
  fi
  
  info "Instalando soporte para config-manager"
  run sudo dnf install -y dnf-plugins-core

  info "Añadiendo repo oficial de Brave para Fedora 41+ / DNF5"
  run sudo dnf config-manager addrepo \
    --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
}

enable_rpmfusion
enable_terra
enable_brave_repo

success "Repositorios externos configurados"
