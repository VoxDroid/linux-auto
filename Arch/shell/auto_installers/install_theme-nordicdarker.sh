#!/bin/bash

# Installs Nordic Darker themes (GTK and icons) for Arch Linux
# Downloads, installs locally (~/.themes, ~/.icons) and globally (/usr/share/themes, /usr/share/icons), then cleans up
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

read -p "Install Nordic Darker themes (GTK and icons) locally and globally? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_error "Script execution cancelled"
fi

log_info "Installing dependencies..."
pacman -S --needed --noconfirm xz tar wget || log_error "Failed to install dependencies"

TEMP_DIR="/tmp/nordic-darker-themes"
mkdir -p "$TEMP_DIR" || log_error "Failed to create temporary directory"

THEME_URLS=(
    "https://github.com/EliverLara/Nordic/releases/download/v2.2.0/Nordic-darker-standard-buttons-v40.tar.xz"
    "https://github.com/EliverLara/Nordic/releases/download/v2.2.0/Nordic-darker-standard-buttons.tar.xz"
    "https://github.com/EliverLara/Nordic/releases/download/v2.2.0/Nordic-darker-v40.tar.xz"
    "https://github.com/EliverLara/Nordic/releases/download/v2.2.0/Nordic-darker.tar.xz"
)

log_info "Downloading Nordic Darker theme files..."
for url in "${THEME_URLS[@]}"; do
    filename=$(basename "$url")
    wget -q "$url" -O "$TEMP_DIR/$filename" || log_error "Failed to download $filename"
done

log_info "Installing themes locally for user $SUDO_USER..."
LOCAL_THEME_DIR="/home/$SUDO_USER/.themes"
LOCAL_ICON_DIR="/home/$SUDO_USER/.icons"
mkdir -p "$LOCAL_THEME_DIR" "$LOCAL_ICON_DIR" || log_error "Failed to create local theme/icon directories"
chown "$SUDO_USER:$SUDO_USER" "$LOCAL_THEME_DIR" "$LOCAL_ICON_DIR"

for file in "$TEMP_DIR"/*.tar.xz; do
    tar -xf "$file" -C "$TEMP_DIR" || log_error "Failed to extract $file"
    theme_name=$(basename "$file" .tar.xz)
    if [[ -d "$TEMP_DIR/$theme_name" ]]; then
        if [[ -f "$TEMP_DIR/$theme_name/index.theme" ]]; then
            mv "$TEMP_DIR/$theme_name" "$LOCAL_ICON_DIR/" || log_error "Failed to install $theme_name to local icons"
        else
            mv "$TEMP_DIR/$theme_name" "$LOCAL_THEME_DIR/" || log_error "Failed to install $theme_name to local themes"
        fi
    fi
done
chown -R "$SUDO_USER:$SUDO_USER" "$LOCAL_THEME_DIR" "$LOCAL_ICON_DIR"

log_info "Installing themes globally..."
GLOBAL_THEME_DIR="/usr/share/themes"
GLOBAL_ICON_DIR="/usr/share/icons"
mkdir -p "$GLOBAL_THEME_DIR" "$GLOBAL_ICON_DIR" || log_error "Failed to create global theme/icon directories"

for file in "$TEMP_DIR"/*.tar.xz; do
    tar -xf "$file" -C "$TEMP_DIR" || log_error "Failed to extract $file"
    theme_name=$(basename "$file" .tar.xz)
    if [[ -d "$TEMP_DIR/$theme_name" ]]; then
        if [[ -f "$TEMP_DIR/$theme_name/index.theme" ]]; then
            mv "$TEMP_DIR/$theme_name" "$GLOBAL_ICON_DIR/" || log_error "Failed to install $theme_name to global icons"
        else
            mv "$TEMP_DIR/$theme_name" "$GLOBAL_THEME_DIR/" || log_error "Failed to install $theme_name to global themes"
        fi
    fi
done

log_info "Cleaning up temporary files..."
rm -rf "$TEMP_DIR" || log_warn "Failed to clean up temporary directory"

log_info "Nordic Darker themes installation complete! Configure themes via your desktop environment's settings."