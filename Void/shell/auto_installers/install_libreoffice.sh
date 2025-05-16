#!/bin/bash

# Installs LibreOffice productivity tool for Void Linux
# Run with sudo: sudo bash install_libreoffice.sh

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

read -p "Install LibreOffice productivity tool? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_error "Script execution cancelled"
fi

log_info "Updating system..."
xbps-install -Su || log_error "Failed to update system"

log_info "Installing LibreOffice..."
xbps-install -S --yes libreoffice || log_error "Failed to install libreoffice"

log_info "Installing Flatpak..."
if ! command -v flatpak &>/dev/null; then
    xbps-install -S --yes flatpak || log_error "Failed to install Flatpak"
else
    log_info "Flatpak is already installed"
fi

log_info "Cleaning package cache..."
xbps-remove -O || log_warn "Failed to clean package cache"

log_info "LibreOffice installation complete!"