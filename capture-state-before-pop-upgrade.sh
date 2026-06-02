#!/usr/bin/env bash
set -Eeuo pipefail

BACKUP_DIR="$HOME/pre-upgrade-backup-$(date +%Y%m%d-%H%M%S)"

mkdir -p "$BACKUP_DIR"

echo "[1/12] Package inventory"
dpkg --get-selections > "$BACKUP_DIR/packages.txt"

echo "[2/12] APT repositories"
grep -R ^deb /etc/apt/sources.list* > "$BACKUP_DIR/apt-repos.txt" 2>/dev/null || true

echo "[3/12] Held packages"
apt-mark showhold > "$BACKUP_DIR/held-packages.txt"

echo "[4/12] Flatpaks"
flatpak list > "$BACKUP_DIR/flatpaks.txt" 2>/dev/null || true

echo "[5/12] User services"
systemctl --user list-unit-files > "$BACKUP_DIR/user-services.txt"

echo "[6/12] OBS config"
cp -a ~/.config/obs-studio "$BACKUP_DIR/" 2>/dev/null || true

echo "[7/12] V4L2 loopback"
lsmod | grep v4l2loopback > "$BACKUP_DIR/v4l2loopback.txt" || true

echo "[8/12] Webcam devices"
v4l2-ctl --list-devices > "$BACKUP_DIR/webcams.txt" 2>/dev/null || true

echo "[9/12] PipeWire"
pw-cli ls > "$BACKUP_DIR/pipewire.txt" 2>/dev/null || true

echo "[10/12] GPU"
lspci -nnk > "$BACKUP_DIR/pci.txt"

echo "[11/12] Current release"
cat /etc/pop-os/os-release > "$BACKUP_DIR/os-release.txt"

echo "[12/12] Kernel"
uname -a > "$BACKUP_DIR/kernel.txt"

echo
echo "Backup saved to:"
echo "$BACKUP_DIR"
