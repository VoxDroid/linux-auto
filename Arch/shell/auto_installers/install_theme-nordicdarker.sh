#!/bin/bash

# Installs all Nordic GTK themes from the EliverLara/Nordic repository for Arch Linux
# Clones the repository, installs themes locally (~/.themes) and globally (/usr/share/themes), then cleans up
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

read -p "Install all Nordic GTK themes locally and globally? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_error "Script execution cancelled"
fi

log_info "Installing dependencies..."
pacman -S --needed --noconfirm xz tar wget git || log_error "Failed to install dependencies"

TEMP_DIR="/tmp/nordic-themes"
REPO_URL="https://github.com/EliverLara/Nordic.git"
mkdir -p "$TEMP_DIR" || log_error "Failed to create temporary directory"

log_info "Cloning Nordic theme repository..."
git clone --depth 1 "$REPO_URL" "$TEMP_DIR/nordic" || log_error "Failed to clone Nordic repository"

log_info "Installing themes locally for user $SUDO_USER..."
LOCAL_THEME_DIR="/home/$SUDO_USER/.themes"
mkdir -p "$LOCAL_THEME_DIR" || log_error "Failed to create local theme directory"
chown "$SUDO_USER:$SUDO_USER" "$LOCAL_THEME_DIR"

for theme_dir in "$TEMP_DIR/nordic"/*/ ; do
    if [[ -d "$theme_dir" && ( -d "$theme_dir/gtk-3.0" || -d "$theme_dir/gtk-4.0" ) ]]; then
        theme_name=$(basename "$theme_dir")
        cp -r "$theme_dir" "$LOCAL_THEME_DIR/$theme_name" || log_error "Failed to install $theme_name to local themes"
    fi
done
chown -R "$SUDO_USER:$SUDO_USER" "$LOCAL_THEME_DIR"

log_info "Installing themes globally..."
GLOBAL_THEME_DIR="/usr/share/themes"
mkdir -p "$GLOBAL_THEME_DIR" || log_error "Failed to create global theme directory"

for theme_dir in "$TEMP_DIR/nordic"/*/ ; do
    if [[ -d "$theme_dir" && ( -d "$theme_dir/gtk-3.0" || -d "$theme_dir/gtk-4.0" ) ]]; then
        theme_name=$(basename "$theme_dir")
        cp -r "$theme_dir" "$GLOBAL_THEME_DIR/$theme_name" || log_error "Failed to install $theme_name to global themes"
    fi
done

log_info "Cleaning up temporary files..."
rm -rf "$TEMP_DIR" || log_warn "Failed to clean up temporary directory"

log_info "Nordic GTK themes installation complete! Configure themes via your desktop environment's settings."