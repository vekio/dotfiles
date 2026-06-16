#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="${DOTFILES_SOURCE:-$(chezmoi source-path)}"
source "$ROOT/scripts/lib.sh"

require_fedora

title "NVIDIA driver via RPM Fusion"

if ! rpm -q rpmfusion-nonfree-release >/dev/null 2>&1; then
  fail "RPM Fusion nonfree no está instalado. Ejecuta primero scripts/05-fedora-repos.sh"
fi

if ! lspci | grep -Ei 'nvidia|3d controller|vga compatible controller' | grep -qi nvidia; then
  warn "No detecto GPU NVIDIA con lspci"
  if ! confirm "Continuar igualmente?" "no"; then
    exit 0
  fi
fi

if mokutil --sb-state 2>/dev/null | grep -qi enabled; then
  warn "Secure Boot parece estar activado."
  warn "Con NVIDIA en Fedora normalmente tendrás que firmar módulos o desactivar Secure Boot."
  warn "No automatizo esto a ciegas para no dejarte sin entorno gráfico."
fi

info "Instalando driver NVIDIA recomendado por RPM Fusion"

run sudo dnf install -y akmod-nvidia

run sudo dnf install -y xorg-x11-drv-nvidia-cuda nvidia-settings

info "Forzando construcción inicial de akmods"
run sudo akmods --force || true

info "Regenerando initramfs"
run sudo dracut --force || true

success "NVIDIA instalado. Reinicia antes de validar rendimiento gráfico."
warn "Tras reiniciar, comprueba con: nvidia-smi"
