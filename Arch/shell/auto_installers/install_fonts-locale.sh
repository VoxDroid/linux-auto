#!/bin/bash

# Installs fonts and generates locales for Arch Linux
# Run with sudo: sudo bash install_fonts_locales.sh

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

read -p "Install fonts and generate all locales? (y/N): " confirm
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

log_info "Installing fonts..."
pacman -S --needed --noconfirm \
    ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji noto-fonts-cjk \
    adobe-source-code-pro-fonts adobe-source-sans-pro-fonts adobe-source-serif-pro-fonts || log_error "Failed to install fonts"

log_info "Installing Poppins Font..."
sudo -u "$SUDO_USER" yay -S --needed --noconfirm ttf-poppins || log_error "Failed to install Poppins Font"

log_info "Generating all locales..."
sed -i 's/^#\([a-zA-Z0-9._-]\+\s\+[a-zA-Z0-9._-]\+\)/\1/' /etc/locale.gen || log_error "Failed to uncomment locales"
locale-gen || log_error "Failed to generate locales"
echo "LANG=en_US.UTF-8" > /etc/locale.conf || log_error "Failed to set default locale"

log_info "Listing installed locales..."
locale -a

log_info "Cleaning package cache..."
paccache -r || log_warn "Failed to clean package cache"

log_info "Fonts and locales installation complete!"