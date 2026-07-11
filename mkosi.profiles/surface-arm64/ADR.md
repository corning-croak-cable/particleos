# ADR: Surface ARM64 Snapdragon X Elite - Design Decisions

## 1. Upstream kernel (no linux-surface)
x1e80100 DTBs (romulus13/15) merged upstream since 6.12.
linux-surface provides no aarch64 packages.
Trade-off: camera (MIPI/IPU6) and full audio non-functional until upstreamed.
Source: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/boot/dts/qcom

## 2. SignExpectedPcr=no
Qualcomm fTPM unavailable during initrd phase -> PCR measurement hang.
Disk encryption works without PCR binding; policy just less boot-state-tied.
Source: linux-surface/linux-surface#1590, community testing.

## 3. sbctl firstboot, no MokManager
Surface NX Mode freezes MokManager at UEFI logo.
ParticleOS UKI + systemd-boot never touches shim/MokManager.
sbctl generates keys on firstboot; PK exported for direct UEFI db enrollment.
Source: https://github.com/linux-surface/linux-surface/issues/1590

## 4. s2idle only (SuspendState=freeze)
Snapdragon X Elite PSCI/ACPI exposes only s2idle on Linux; S3 unavailable.
Trade-off: higher suspend battery drain than Windows.
