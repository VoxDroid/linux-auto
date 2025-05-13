#!/bin/bash

# Installs fonts and generates locales for Void Linux
# Run with sudo: sudo bash install_fonts_locales_void.sh

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
xbps-install -Su || log_error "Failed to update system"

log_info "Installing fonts..."
xbps-install -S --yes \
    dejavu-fonts-ttf font-liberation-ttf noto-fonts-ttf noto-fonts-ttf-extra || log_error "Failed to install fonts"

log_info "Installing Poppins font..."
# Poppins is not in Void repos or Flathub as a font package, so download from Google Fonts
sudo -u "$SUDO_USER" bash -c '
    mkdir -p ~/.local/share/fonts/poppins
    cd /tmp
    wget -q https://fonts.google.com/download?family=Poppins -O poppins.zip || exit 1
    unzip -q poppins.zip -d poppins || exit 1
    mv poppins/*.ttf ~/.local/share/fonts/poppins/ || exit 1
    fc-cache -fv || exit 1
    rm -rf poppins poppins.zip
' || log_error "Failed to install Poppins font"

log_info "Generating all locales..."
# Uncomment all locales in /etc/default/libc-locales
sed -i 's/^#\([a-zA-Z0-9._-]\+\s\+[a-zA-Z0-9._-]\+\)/\1/' /etc/default/libc-locales || log_error "Failed to uncomment locales"
xbps-reconfigure -f glibc-locales || log_error "Failed to generate locales"
echo "LANG=en_US.UTF-8" > /etc/locale.conf || log_error "Failed to set default locale"

log_info "Listing installed locales..."
locale -a

log_info "Cleaning package cache..."
xbps-remove -O || log_warn "Failed to clean package cache"

log_info "Fonts and locales installation complete!"