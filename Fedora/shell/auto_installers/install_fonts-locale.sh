#!/bin/bash

# Installs fonts and generates locales for Fedora/RHEL-based systems
# Run with sudo: sudo bash install_fonts_locales_fedora.sh

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
dnf update -y || log_error "Failed to update system"

log_info "Installing required tools..."
dnf install -y curl wget fontconfig || log_error "Failed to install required tools"

log_info "Installing fonts..."
dnf install -y \
    dejavu-sans-fonts dejavu-serif-fonts \
    liberation-sans-fonts liberation-serif-fonts \
    google-noto-sans-fonts google-noto-serif-fonts \
    google-noto-cjk-fonts google-noto-emoji-fonts || log_error "Failed to install fonts"

log_info "Refreshing font cache..."
fc-cache -fv || log_warn "Failed to refresh font cache"

log_info "Generating all locales..."
# Fedora uses /etc/locale.conf for default locale settings
echo "LANG=en_US.UTF-8" > /etc/locale.conf || log_error "Failed to set default locale"
# Generate all locales available in glibc
localedef -i "$(localedef --list-archive | grep -v '^C\.' | awk -F. '{print $1}' | sort -u)" -f UTF-8 /usr/lib/locale || log_error "Failed to generate locales"

log_info "Listing installed locales..."
locale -a

log_info "Cleaning package cache..."
dnf autoremove -y && dnf clean all || log_warn "Failed to clean package cache"

log_info "Fonts and locales installation complete!"