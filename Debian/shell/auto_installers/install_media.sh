#!/bin/bash

# Installs media tools for Debian/Ubuntu (GIMP, VLC, Kdenlive, etc.)
# Run with sudo: sudo bash install_media_debian.sh

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

read -p "Install media tools (GIMP, VLC, etc.)? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_error "Script execution cancelled"
fi

log_info "Updating system..."
apt update && apt upgrade -y || log_error "Failed to update system"

log_info "Installing media tools..."
apt install -y \
    gimp vlc flameshot kolourpaint audacity kdenlive krita inkscape || log_error "Failed to install media tools"

log_info "Cleaning package cache..."
apt autoremove -y && apt autoclean || log_warn "Failed to clean package cache"

log_info "Media tools installation complete!"