#!/bin/bash

# Installs essential applications for Arch Linux (browsers, Gwenview, file managers, etc.)
# Run with sudo: sudo bash install_essentials.sh

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

read -p "Install essential applications (browsers, Gwenview, etc.)? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_error "Script execution cancelled"
fi

log_info "Updating system..."
pacman -Syu --noconfirm || log_error "Failed to update system"

if ! command -v yay &>/dev/null; then
    log_info "Installing Yay AUR helper..."
    pacman -S --needed --noconfirm base-devel git || log_error "Failed to install base-devel and git"
    cd /tmp
    git clone https://aur.archlinux.org/yay.git || log_error "Failed to clone Yay repository"
    cd yay
    sudo -u "$SUDO_USER" makepkg -si --noconfirm || log_error "Failed to install Yay"
    cd ..
    rm -rf yay
else
    log_info "Yay is already installed"
fi

log_info "Installing essential applications..."
pacman -S --needed --noconfirm \
    torbrowser-launcher \
    gwenview dolphin \
    terminator tree || log_error "Failed to install essential applications"

log_info "Installing Brave browser..."
sudo -u "$SUDO_USER" yay -S --needed --noconfirm brave-bin || log_error "Failed to install Brave"

log_info "Cleaning package cache..."
paccache -r || log_warn "Failed to clean package cache"

log_info "Essentials installation complete!"