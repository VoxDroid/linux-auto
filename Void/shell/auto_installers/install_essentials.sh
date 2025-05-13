#!/bin/bash

# Installs essential applications for Void Linux (browsers, Gwenview, file managers, etc.)
# Run with sudo: sudo bash install_essentials_void.sh

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
xbps-install -Su || log_error "Failed to update system"

log_info "Installing essential applications..."
xbps-install -S --yes \
    wget curl rsync \
    zip unzip \
    tar gzip bzip2 lzop zstd \
    p7zip \
    jq yq \
    bind \
    torbrowser-launcher \
    terminator tree \
    vim neovim \
    neofetch tmux \
    NetworkManager || log_error "Failed to install essential applications"

log_info "Setting up Flatpak for Brave browser..."
if ! command -v flatpak &>/dev/null; then
    log_info "Installing Flatpak..."
    xbps-install -S --yes flatpak || log_error "Failed to install Flatpak"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || log_error "Failed to add Flathub repo"
else
    log_info "Flatpak is already installed"
fi

log_info "Installing Brave browser via Flatpak..."
sudo -u "$SUDO_USER" flatpak install -y flathub com.brave.Browser || log_error "Failed to install Brave browser"

log_info "Cleaning package cache..."
xbps-remove -O || log_warn "Failed to clean package cache"

log_info "Essentials installation complete!"