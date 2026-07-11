#!/bin/bash
# SPDX-License-Identifier: LGPL-2.1-or-later
# Surface Laptop 7 Secure Boot enrollment helper
# Source: https://github.com/Foxboron/sbctl
# Source: https://github.com/linux-surface/linux-surface/issues/1590

set -euo pipefail

INSTRUCTIONS_DIR=/var/lib/surface-sb-enroll
mkdir -p "$INSTRUCTIONS_DIR"

echo "[surface-sb-enroll] Generating sbctl Secure Boot keys..."
sbctl create-keys

for uki in /efi/EFI/Linux/*.efi /boot/EFI/Linux/*.efi; do
  [ -f "$uki" ] || continue
  echo "[surface-sb-enroll] Signing: $uki"
  sbctl sign "$uki"
done

if [ -f /var/lib/sbctl/keys/PK/PK.pem ]; then
  openssl x509 -in /var/lib/sbctl/keys/PK/PK.pem -outform DER -out "$INSTRUCTIONS_DIR/ParticleOS-PK.cer"
  echo "[surface-sb-enroll] Platform Key exported: $INSTRUCTIONS_DIR/ParticleOS-PK.cer"
fi

cat > "$INSTRUCTIONS_DIR/ENROLL_SECURE_BOOT.md" << HEREDOC
# ParticleOS Secure Boot Enrollment - Surface Laptop 7

Keys generated. To enable Secure Boot:

1. Copy Platform Key to EFI partition:
   cp /var/lib/surface-sb-enroll/ParticleOS-PK.cer /efi/ParticleOS-PK.cer

2. Enter Surface UEFI: hold Volume Up + Power while powering on.

3. Navigate to Security -> Secure Boot -> disable, then Reset to Setup Mode.

4. Enroll Platform Key from file (select ParticleOS-PK.cer).
   OR from Linux (SB disabled): sbctl enroll-keys --microsoft

5. Re-enable Secure Boot. Firmware should show Custom Key Configuration.

Verify: bootctl status | grep -i secure && sbctl status

WHY NOT MokManager: Surface NX Mode causes MokManager to hang (black screen).
ParticleOS uses UKI + systemd-boot with no shim, so MokManager is never invoked.
Ref: https://github.com/linux-surface/linux-surface/issues/1590
HEREDOC

echo "[surface-sb-enroll] Done. Read: $INSTRUCTIONS_DIR/ENROLL_SECURE_BOOT.md"
