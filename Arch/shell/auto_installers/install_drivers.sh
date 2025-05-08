#!/bin/bash

# Installs driver-related packages for Arch Linux (linux-firmware, mesa, etc.)
# Run with sudo: sudo bash install_drivers.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

if [[ $EUID -ne 0 ]]; then
    log_error "This script must be run as root (use sudo)"
fi

if [[ -z "$SUDO_USER" ]]; then
    log_error "SUDO_USER not set. Please run this script with sudo."
fi

read -p "Install driver-related packages (linux-firmware, mesa, etc.)? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_error "Script execution cancelled"
fi

log_info "Updating system..."
pacman -Syu --noconfirm || log_error "Failed to update system"

if ! command -v yay &>/dev/null; then
    log_info "Installing Yay AUR helper..."
    pacman -S --needed --noconfirm base-devel git || log_error "Failed to install base-devel and git"
    sudo -u "$SUDO_USER" bash -c '
        cd /tmp
        git clone https://aur.archlinux.org/yay.git || exit 1
        cd yay
        makepkg -si --noconfirm || exit 1
    '
    rm -rf /tmp/yay
else
    log_info "Yay is already installed"
fi

log_info "Installing driver-related packages..."
pacman -S --needed --noconfirm \
    linux-firmware \
    mesa lib32-mesa \
    vulkan-intel vulkan-radeon lib32-vulkan-intel lib32-vulkan-radeon \
    libva-intel-driver libva-mesa-driver \
    xf86-video-amdgpu xf86-video-intel \
    nvidia nvidia-utils lib32-nvidia-utils \
    amd-ucode intel-ucode \
    libvdpau lib32-libvdpau \
    bluez bluez-utils \
    sof-firmware \
    fwupd || log_error "Failed to install driver-related packages"

log_info "Installing Broadcom Wi-Fi driver from AUR..."
sudo -u "$SUDO_USER" yay -S --needed --noconfirm broadcom-wl || log_error "Failed to install broadcom-wl"

log_info "Cleaning package cache..."
paccache -r || log_warn "Failed to clean package cache"

log_info "Driver-related packages installation complete!"