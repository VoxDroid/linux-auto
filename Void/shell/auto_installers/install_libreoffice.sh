#!/bin/bash

# Installs LibreOffice-related productivity tools for Void Linux
# Includes libreoffice, libreoffice-extension-texmaths, libreoffice-extension-writer2latex
# Run with sudo: sudo bash install_productivity_libre_void.sh

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

read -p "Install LibreOffice-related productivity tools? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_error "Script execution cancelled"
fi

log_info "Updating system..."
xbps-install -Su || log_error "Failed to update system"

log_info "Setting up Flatpak for potential extension installation..."
if ! command -v flatpak &>/dev/null; then
    log_info "Installing Flatpak..."
    xbps-install -S --yes flatpak || log_error "Failed to install Flatpak"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || log_error "Failed to add Flathub repo"
else
    log_info "Flatpak is already installed"
fi

log_info "Installing LibreOffice..."
xbps-install -S --yes libreoffice || {
    log_warn "Failed to install libreoffice. Continuing with other installations."
}

log_info "Installing libreoffice-extension-texmaths..."
# Check Flatpak for texmaths (not typically available, so fallback to manual install)
search_result=$(flatpak search texmaths | grep -i texmaths || true)
if [[ -n "$search_result" ]]; then
    app_id=$(echo "$search_result" | awk '{print $1}' | head -n 1)
    log_info "Found libreoffice-extension-texmaths in Flathub as $app_id. Installing..."
    sudo -u "$SUDO_USER" flatpak install -y flathub "$app_id" || log_warn "Failed to install libreoffice-extension-texmaths from Flathub"
else
    log_info "libreoffice-extension-texmaths not found in Flathub. Installing from source..."
    sudo -u "$SUDO_USER" bash -c '
        mkdir -p ~/.local/share/libreoffice/extensions
        cd /tmp
        wget -q https://downloads.sourceforge.net/project/texmaths/TexMaths-0.49.oxt -O TexMaths.oxt || exit 1
        unzip -q TexMaths.oxt -d ~/.local/share/libreoffice/extensions/texmaths || exit 1
        rm TexMaths.oxt
    ' || log_warn "Failed to install libreoffice-extension-texmaths. Continuing with other installations."
fi

log_info "Installing libreoffice-extension-writer2latex..."
# Check Flatpak for writer2latex (not typically available, so fallback to manual install)
search_result=$(flatpak search writer2latex | grep -i writer2latex || true)
if [[ -n "$search_result" ]]; then
    app_id=$(echo "$search_result" | awk '{print $1}' | head -n 1)
    log_info "Found libreoffice-extension-writer2latex in Flathub as $app_id. Installing..."
    sudo -u "$SUDO_USER" flatpak install -y flathub "$app_id" || log_warn "Failed to install libreoffice-extension-writer2latex from Flathub"
else
    log_info "libreoffice-extension-writer2latex not found in Flathub. Installing from source..."
    sudo -u "$SUDO_USER" bash -c '
        mkdir -p ~/.local/share/libreoffice/extensions
        cd /tmp
        wget -q https://sourceforge.net/projects/writer2latex/files/writer2latex/1.0.2/writer2latex.oxt/download -O writer2latex.oxt || exit 1
        unzip -q writer2latex.oxt -d ~/.local/share/libreoffice/extensions/writer2latex || exit 1
        rm writer2latex.oxt
    ' || log_warn "Failed to install libreoffice-extension-writer2latex. Continuing with other installations."
fi

log_info "Cleaning package cache..."
xbps-remove -O || log_warn "Failed to clean package cache"

log_info "LibreOffice-related productivity tools installation complete!"