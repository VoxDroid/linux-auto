#!/bin/bash

# Installs a comprehensive KDE Plasma desktop environment and enhancements for Arch Linux
# Includes core Plasma, applications, themes, utilities, and optional tools
# Run with sudo: sudo bash install_de-plasmakde.sh

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

read -p "Install comprehensive KDE Plasma desktop environment and enhancements (y/N): " confirm
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

log_info "Installing KDE Plasma desktop environment and enhancements..."
pacman -S --needed --noconfirm \
    plasma-desktop plasma-workspace plasma-systemmonitor plasma-thunderbolt \
    plasma-pa plasma-nm plasma-firewall plasma-vault plasma-disks \
    kdeplasma-addons plasma-browser-integration \
    sddm kde-system kde-utilities kde-graphics kde-multimedia kde-network \
    bluedevil powerdevil kscreen kwallet-pam \
    kdenlive krita digikam kmag kmousetool \
    breeze-gtk papirus-icon-theme plasma-sdk \
    krfb krdc || log_error "Failed to install KDE Plasma packages"

log_info "Installing additional KDE themes and tools from AUR..."
sudo -u "$SUDO_USER" yay -S --needed --noconfirm \
    sddm-theme-corners-git plasma5-applets-window-buttons \
    plasma5-applets-eventcalendar || log_warn "Failed to install some AUR packages"

log_info "Enabling SDDM display manager..."
systemctl enable sddm || log_warn "Failed to enable SDDM"

log_info "Cleaning package cache..."
paccache -r || log_warn "Failed to clean package cache"

log_info "Comprehensive KDE Plasma desktop environment installation complete! Configure SDDM and Plasma themes via System Settings."