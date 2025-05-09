#!/bin/bash

# Installs a comprehensive GNOME desktop environment for Arch Linux
# Includes gnome, gnome-core, utilities, themes, and optional tools
# Uses GDM as the display manager
# Run with sudo: sudo bash install_de-gnome.sh

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

read -p "Install comprehensive GNOME desktop environment (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_error "Script execution cancelled"
fi

log_info "Updating system..."
pacman -Syu --noconfirm || log_error "Failed to update system"

log_info "Installing pacman-contrib..."
pacman -S --needed --noconfirm pacman-contrib || log_error "Failed to install pacman-contrib"

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

log_info "Installing GNOME desktop environment..."
pacman -S --needed --noconfirm \
    gnome gdm \
    gnome-tweaks gnome-shell-extensions gnome-control-center \
    gnome-system-monitor gnome-disk-utility gnome-keyring \
    gnome-backgrounds gnome-themes-extra \
    nautilus sushi gnome-terminal gnome-screenshot \
    eog evince file-roller gedit totem \
    orca \
    gnome-remote-desktop || log_error "Failed to install GNOME packages"

log_info "Installing additional GNOME themes and extensions from AUR..."
sudo -u "$SUDO_USER" yay -S --needed --noconfirm \
    gnome-shell-extension-dash-to-dock gnome-shell-extension-appindicator \
    papirus-icon-theme arc-gtk-theme \
    gnome-settings extension-manager || log_warn "Failed to install some AUR packages"

log_info "Enabling GDM display manager..."
systemctl enable gdm || log_warn "Failed to enable GDM"

log_info "Cleaning package cache..."
paccache -r || log_warn "Failed to clean package cache"

log_info "GNOME desktop environment installation complete! Configure GNOME settings via Settings or GNOME Tweaks."