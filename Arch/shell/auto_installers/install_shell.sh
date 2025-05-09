#!/bin/bash

# Installs shell enhancements for Arch Linux (Zsh, Fish, Powerline, etc.)
# Run with sudo: sudo bash install_shell_enhancements.sh

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

read -p "Install shell enhancements (Zsh, Fish, etc.)? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_error "Script execution cancelled"
fi

log_info "Updating system..."
pacman -Syu --noconfirm || log_error "Failed to update system"

log_info "Installing pacman-contrib..."
pacman -S --needed --noconfirm pacman-contrib || log_error "Failed to install pacman-contrib"

log_info "Installing shell enhancements..."
pacman -S --needed --noconfirm \
    zsh fish zsh-autosuggestions zsh-completions zsh-syntax-highlighting \
    powerline powerline-fonts tmux || log_error "Failed to install shell enhancements"

log_info "Cleaning package cache..."
paccache -r || log_warn "Failed to clean package cache"

log_info "Shell enhancements installation complete! Run 'chsh -s /usr/bin/zsh' or 'chsh -s /usr/bin/fish' to switch shells."