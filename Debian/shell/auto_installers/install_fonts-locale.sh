#!/bin/bash

# Installs fonts and generates locales for Debian/Ubuntu
# Run with sudo: sudo bash install_fonts_locales_debian.sh

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
apt update && apt upgrade -y || log_error "Failed to update system"

log_info "Installing required tools..."
apt install -y curl wget fontconfig || log_error "Failed to install required tools"

log_info "Installing fonts..."
apt install -y \
    fonts-dejavu fonts-liberation fonts-noto fonts-noto-cjk fonts-noto-color-emoji \
    fonts-source-code-pro fonts-adobe-sourcesans3 fonts-adobe-sourceserif4 || log_error "Failed to install fonts"

log_info "Installing Poppins Font..."
mkdir -p /usr/share/fonts/truetype/poppins
wget -q -O /tmp/poppins.zip "https://fonts.google.com/download?family=Poppins" || log_error "Failed to download Poppins Font"
unzip -q /tmp/poppins.zip -d /usr/share/fonts/truetype/poppins || log_error "Failed to unzip Poppins Font"
rm /tmp/poppins.zip
fc-cache -f || log_warn "Failed to update font cache"

log_info "Generating all locales..."
sed -i 's/^#\([a-zA-Z0-9._-]\+\s\+[a-zA-Z0-9._-]\+\)/\1/' /etc/locale.gen || log_error "Failed to uncomment locales"
locale-gen || log_error "Failed to generate locales"
echo "LANG=en_US.UTF-8" > /etc/default/locale || log_error "Failed to set default locale"

log_info "Listing installed locales..."
locale -a

log_info "Cleaning package cache..."
apt autoremove -y && apt autoclean || log_warn "Failed to clean package cache"

log_info "Fonts and locales installation complete!"