#!/usr/bin/env bash
#
# Install the NVIDIA driver from RPM Fusion and enable NVIDIA CDI for Podman.
# This script is intentionally optional and aborts on risky conditions.

set -Eeuo pipefail

SCRIPTS="${DOTFILES_SCRIPTS:-$HOME/.local/share/dotfiles/scripts}"
source "$SCRIPTS/lib.sh"

require_fedora

FORCE=0

for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    -h|--help)
      printf "Usage: %s [--force]\n" "$0"
      exit 0
      ;;
    *) fail "Unknown argument: $arg" ;;
  esac
done

title "NVIDIA driver"

if ! rpm -q rpmfusion-nonfree-release >/dev/null 2>&1; then
  fail "RPM Fusion nonfree is not configured. Run 05-fedora-repos.sh first."
fi

if has lspci; then
  if ! lspci | grep -Ei 'nvidia|3d controller|vga compatible controller' | grep -qi nvidia; then
    if [ "$FORCE" = "1" ]; then
      warn "No NVIDIA GPU detected with lspci; continuing because --force was set"
    else
      fail "No NVIDIA GPU detected with lspci. Use --force to override."
    fi
  fi
else
  warn "lspci is not available; skipping GPU detection"
fi

if has mokutil && mokutil --sb-state 2>/dev/null | grep -qi enabled; then
  if [ "$FORCE" = "1" ]; then
    warn "Secure Boot appears enabled; continuing because --force was set"
  else
    fail "Secure Boot appears enabled. Disable it or handle module signing, then re-run with --force if intentional."
  fi
fi

detail "Installing NVIDIA packages"
run sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda nvidia-settings

detail "Configuring NVIDIA Container Toolkit repository"
if [ ! -f /etc/yum.repos.d/nvidia-container-toolkit.repo ]; then
  run bash -c 'curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo >/dev/null'
else
  detail "NVIDIA Container Toolkit repository already configured"
fi

detail "Installing NVIDIA Container Toolkit"
run sudo dnf install -y nvidia-container-toolkit

detail "Building akmods"
run sudo akmods --force

detail "Regenerating initramfs"
run sudo dracut --force

detail "Enabling NVIDIA CDI refresh"
run sudo systemctl enable --now nvidia-cdi-refresh.path
run sudo systemctl enable --now nvidia-cdi-refresh.service

success "NVIDIA driver installed. Reboot, then verify with: nvidia-smi"
info "Podman GPU test: podman run --rm --device nvidia.com/gpu=all --security-opt=label=disable ubuntu nvidia-smi -L"
