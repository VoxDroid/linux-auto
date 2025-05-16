#!/bin/bash

# Installs Nordic Darker GTK themes and Nordic folder icons for Void Linux
# Downloads Nordic-darker and Nordic-darker-v40 GTK themes, clones Nordic repo for folder icons,
# installs locally (~/.themes, ~/.icons) and globally (/usr/share/themes, /usr/share/icons), then cleans up
# Run with sudo: sudo bash install_theme-nordicdarker_void.sh

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

read -p "Install Nordic Darker GTK themes and Nordic folder icons locally and globally? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_error "Script execution cancelled"
fi

log_info "Installing dependencies..."
xbps-install -S --yes xz tar wget git || log_error "Failed to install dependencies"

TEMP_DIR="/tmp/nordic-darker-themes"
mkdir -p "$TEMP_DIR" || log_error "Failed to create temporary directory"
chown "$SUDO_USER:$SUDO_USER" "$TEMP_DIR" || log_error "Failed to set permissions for temporary directory"

# Download GTK themes
THEME_URLS=(
    "https://github.com/EliverLara/Nordic/releases/download/v2.2.0/Nordic-darker.tar.xz"
    "https://github.com/EliverLara/Nordic/releases/download/v2.2.0/Nordic-darker-v40.tar.xz"
)

log_info "Downloading Nordic Darker GTK theme files..."
for url in "${THEME_URLS[@]}"; do
    filename=$(basename "$url")
    wget -q "$url" -O "$TEMP_DIR/$filename" || log_error "Failed to download $filename"
done

# Clone Nordic repository for folder icons
log_info "Cloning Nordic repository for folder icons..."
sudo -u "$SUDO_USER" --set-home git clone https://github.com/EliverLara/Nordic.git "$TEMP_DIR/Nordic" || log_error "Failed to clone Nordic repository"

# Install GTK themes locally
log_info "Installing GTK themes locally for user $SUDO_USER..."
LOCAL_THEME_DIR="/home/$SUDO_USER/.themes"
sudo -u "$SUDO_USER" --set-home mkdir -p "$LOCAL_THEME_DIR" || log_error "Failed to create local theme directory"

for file in "$TEMP_DIR"/*.tar.xz; do
    theme_name=$(basename "$file" .tar.xz)
    sudo -u "$SUDO_USER" --set-home tar -xf "$file" -C "$TEMP_DIR" || log_error "Failed to extract $file"
    if [[ -d "$TEMP_DIR/$theme_name" ]]; then
        sudo -u "$SUDO_USER" --set-home mv "$TEMP_DIR/$theme_name" "$LOCAL_THEME_DIR/" || log_error "Failed to install $theme_name to local themes"
    fi
done

# Install folder icons locally
log_info "Installing folder icons locally for user $SUDO_USER..."
LOCAL_ICON_DIR="/home/$SUDO_USER/.icons"
sudo -u "$SUDO_USER" --set-home mkdir -p "$LOCAL_ICON_DIR" || log_error "Failed to create local icon directory"

if [[ -d "$TEMP_DIR/Nordic/kde/folders" ]]; then
    for folder in "$TEMP_DIR/Nordic/kde/folders"/*; do
        if [[ -d "$folder" ]]; then
            folder_name=$(basename "$folder")
            sudo -u "$SUDO_USER" --set-home cp -r "$folder" "$LOCAL_ICON_DIR/$folder_name" || log_error "Failed to install $folder_name to local icons"
        fi
    done
else
    log_warn "No folder icons found in Nordic/kde/folders"
fi

# Install GTK themes globally
log_info "Installing GTK themes globally..."
GLOBAL_THEME_DIR="/usr/share/themes"
mkdir -p "$GLOBAL_THEME_DIR" || log_error "Failed to create global theme directory"

for file in "$TEMP_DIR"/*.tar.xz; do
    theme_name=$(basename "$file" .tar.xz)
    tar -xf "$file" -C "$TEMP_DIR" || log_error "Failed to extract $file"
    if [[ -d "$TEMP_DIR/$theme_name" ]]; then
        mv "$TEMP_DIR/$theme_name" "$GLOBAL_THEME_DIR/" || log_error "Failed to install $theme_name to global themes"
    fi
done

# Install folder icons globally
log_info "Installing folder icons globally..."
GLOBAL_ICON_DIR="/usr/share/icons"
mkdir -p "$GLOBAL_ICON_DIR" || log_error "Failed to create global icon directory"

if [[ -d "$TEMP_DIR/Nordic/kde/folders" ]]; then
    for folder in "$TEMP_DIR/Nordic/kde/folders"/*; do
        if [[ -d "$folder" ]]; then
            folder_name=$(basename "$folder")
            cp -r "$folder" "$GLOBAL_ICON_DIR/$folder_name" || log_error "Failed to install $folder_name to global icons"
        fi
    done
else
    log_warn "No folder icons found in Nordic/kde/folders"
fi

# Update icon cache
log_info "Updating icon cache..."
for folder in "$GLOBAL_ICON_DIR"/*; do
    if [[ -d "$folder" && -f "$folder/index.theme" ]]; then
        gtk-update-icon-cache -f "$folder" || log_warn "Failed to update icon cache for $folder"
    fi
done

# Clean up temporary files
log_info "Cleaning up temporary files..."
rm -rf "$TEMP_DIR" || log_warn "Failed to clean up temporary directory"

log_info "Nordic Darker GTK themes and folder icons installation complete! Configure themes and icons via your desktop environment's settings."