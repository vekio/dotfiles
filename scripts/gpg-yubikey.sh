#!/usr/bin/env bash
set -euo pipefail

echo "==> Habilitando pcscd.socket..."
sudo systemctl enable --now pcscd.socket

echo "==> Asegurando pcscd activo ahora..."
sudo systemctl start pcscd || true

echo "==> Reiniciando agentes de GPG..."
gpgconf --kill gpg-agent || true
gpgconf --kill scdaemon || true

echo "==> Reiniciando pcscd..."
sudo systemctl restart pcscd || true

echo "==> Estado:"
systemctl is-enabled pcscd.socket
systemctl is-active pcscd.socket || true
systemctl is-active pcscd || true

echo
echo "Ahora prueba:"
echo "  gpg --card-status"

# LUKS

LUKS_DEVICE="${1:-}"

if [[ -z "$LUKS_DEVICE" ]]; then
  echo "Uso: $0 /dev/nvme0n1pX"
  echo
  echo "Discos detectados:"
  lsblk -f
  exit 1
fi

echo "==> Comprobando dispositivo LUKS: $LUKS_DEVICE"
sudo cryptsetup luksDump "$LUKS_DEVICE" | grep "Version:" || {
  echo "No parece un volumen LUKS válido: $LUKS_DEVICE"
  exit 1
}

if ! sudo cryptsetup luksDump "$LUKS_DEVICE" | grep -q "Version:[[:space:]]*2"; then
  echo "Este método requiere LUKS2."
  exit 1
fi

echo "==> Instalando herramientas necesarias..."
sudo dnf install -y \
  systemd \
  cryptsetup \
  fido2-tools \
  yubikey-manager

ykman fido access change-pin
ykman fido info


echo "==> Añadiendo módulo fido2 a dracut..."
echo 'add_dracutmodules+=" fido2 "' | sudo tee /etc/dracut.conf.d/fido2.conf
/dev/nvme0n1p3
echo "==> Registrando YubiKey/FIDO2 en LUKS..."
echo "Te pedirá la passphrase actual de LUKS y luego PIN/touch de la YubiKey."
sudo systemd-cryptenroll --fido2-device=auto "$LUKS_DEVICE"

sudo systemd-cryptenroll \
  --fido2-device=auto \
  --fido2-with-client-pin=yes \
  --fido2-with-user-presence=no \
  /dev/nvme0n1p3

echo "==> Mostrando nombre UUID para /etc/crypttab..."
UUID="$(sudo blkid -s UUID -o value "$LUKS_DEVICE")"
echo "UUID detectado: $UUID"
echo
echo "Ahora revisa /etc/crypttab y añade fido2-device=auto a la línea correspondiente."
echo "Ejemplo:"
echo
echo "  luks-$UUID UUID=$UUID none discard,fido2-device=auto"
echo
echo "Edita con:"
echo "  sudoedit /etc/crypttab"
echo
read -r -p "Pulsa Enter cuando hayas editado /etc/crypttab..."

echo "==> Regenerando initramfs..."
sudo dracut -f

echo "==> Hecho."
echo
echo "En el próximo arranque deberías poder desbloquear con:"
echo "  1. PIN de la YubiKey"
echo "  2. toque físico en la YubiKey"
echo
echo "Mantén SIEMPRE la passphrase de LUKS como respaldo."
