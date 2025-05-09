#!/bin/bash

# Installs version control systems and related tools for Arch Linux
# Run with sudo: sudo bash install_vcs.sh

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

read -p "Install version control systems and tools? (y/N): " confirm
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

log_info "Installing version control systems and tools..."
pacman -S --needed --noconfirm \
    git \
    mercurial \
    subversion \
    cvs \
    git-lfs \
    tig \
    meld \
    kdiff3 \
    || log_error "Failed to install VCS tools"

log_info "Installing GitHub Desktop..."
sudo -u "$SUDO_USER" yay -S --needed --noconfirm github-desktop-bin || log_error "Failed to install GitHub Desktop"

log_info "Cleaning package cache..."
paccache -r || log_warn "Failed to clean package cache"

log_info "VCS tools installation complete!"