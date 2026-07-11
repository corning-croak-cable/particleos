# Surface ARM64 - Snapdragon X Elite (Surface Laptop 7)

ParticleOS profile for Surface Laptop 7 (x1e80100, arm64).
Design priorities: bootable images first, TPM enrollment quirks resolved, upstream kernel only.
See ADR.md for full rationale.

## Hardware status (kernel 6.15+)

| Component | Status | Notes |
|---|---|---|
| Boot (systemd-boot + UKI) | Works | Direct UEFI, no shim |
| CPU (Oryon 12-core) | Works | Full cpufreq |
| NVMe (PCIe Gen 4) | Works | |
| Display (eDP 120Hz) | Works | Freedreno/DRM |
| WiFi (WCN785x/ath12k) | Works | Needs linux-firmware blobs |
| USB-A / USB-C | Works | USB4/TB limited |
| Suspend (s2idle) | Works | No S3; higher drain |
| TPM2 disk encryption | Works | No PCR binding (fTPM quirk) |
| Secure Boot | Manual setup | See below |
| Audio | Partial | Windows firmware blobs needed |
| Camera | Not working | IPU6/MIPI unmerged |
| Touchscreen | Not working | HID-over-SPI unmerged |

## Build

    mkosi --profile obs-repos --profile desktop --profile gnome --profile surface-arm64 build

Cross-building from x86-64: requires qemu-user-static + binfmt-misc.

## Secure Boot enrollment

1. Disable Secure Boot in Surface UEFI (Volume Up + Power -> Security).
2. Boot ParticleOS. surface-sb-enroll.service runs on first boot.
3. cat /var/lib/surface-sb-enroll/ENROLL_SECURE_BOOT.md
4. Enroll ParticleOS-PK.cer in Surface UEFI.
5. Re-enable Secure Boot.

MokManager never used. Surface NX Mode freezes it.
Ref: https://github.com/linux-surface/linux-surface/issues/1590
