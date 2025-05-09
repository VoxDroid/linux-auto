#!/bin/bash

# Installs the entire Nordic theme repository as a single folder for Arch Linux
# Clones the repository, places the Nordic folder in local (~/.themes) and global (/usr/share/themes), then cleans up
# Run with sudo: sudo bash install_theme-nordicdarker.sh

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

read -p "Install the entire Nordic theme repository locally and globally? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_error "Script execution cancelled"
fi

log_info "Installing dependencies..."
pacman -S --needed --noconfirm git xz tar || log_error "Failed to install dependencies"

TEMP_DIR="/tmp/nordic-themes"
REPO_URL="https://github.com/EliverLara/Nordic.git"

log_info "Cloning Nordic theme repository..."
rm -rf "$TEMP_DIR"  # Ensure clean directory
git clone "$REPO_URL" "$TEMP_DIR" || log_error "Failed to clone Nordic repository"

log_info "Installing themes locally for user $SUDO_USER..."
LOCAL_THEME_DIR="/home/$SUDO_USER/.themes"
mkdir -p "$LOCAL_THEME_DIR" || log_error "Failed to create local theme directory"
chown "$SUDO_USER:$SUDO_USER" "$LOCAL_THEME_DIR"

# Move the entire Nordic folder to local themes
mv "$TEMP_DIR" "$LOCAL_THEME_DIR/Nordic" || log_error "Failed to install Nordic folder to local themes"
chown -R "$SUDO_USER:$SUDO_USER" "$LOCAL_THEME_DIR/Nordic"

log_info "Installing themes globally..."
GLOBAL_THEME_DIR="/usr/share/themes"
mkdir -p "$GLOBAL_THEME_DIR" || log_error "Failed to create global theme directory"

# Clone again for global installation to avoid moving the local copy
git clone "$REPO_URL" "$TEMP_DIR" || log_error "Failed to clone Nordic repository for global installation"

# Move the entire Nordic folder to global themes
mv "$TEMP_DIR" "$GLOBAL_THEME_DIR/Nordic" || log_error "Failed to install Nordic folder to global themes"

log_info "Cleaning up temporary files..."
rm -rf "$TEMP_DIR" || log_warn "Failed to clean up temporary directory"

log_info "Nordic theme repository installation complete! Configure themes via your desktop environment's settings."