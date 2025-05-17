#!/bin/bash

# Installs productivity tools for Debian/Ubuntu (LibreOffice, Okular, etc.)
# Run with sudo: sudo bash install_productivity_debian.sh

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

read -p "Install productivity tools (LibreOffice, Okular, etc.)? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_error "Script execution cancelled"
fi

log_info "Updating system..."
apt update && apt upgrade -y || log_error "Failed to update system"

log_info "Installing required tools..."
apt install -y curl wget apt-transport-https software-properties-common || log_error "Failed to install required tools"

log_info "Installing productivity tools..."
apt install -y \
    libreoffice libreoffice-texmaths libreoffice-writer2latex \
    okular evince zathura zathura-pdf-poppler \
    hunspell hunspell-en-us || log_error "Failed to install productivity tools"

log_info "Installing OnlyOffice..."
snap install onlyoffice-desktopeditors || log_error "Failed to install OnlyOffice"

log_info "Installing Obsidian..."
snap install obsidian --classic || log_error "Failed to install Obsidian"

log_info "Installing Notion via Snap..."
snap install notion-snap || log_error "Failed to install Notion"

log_info "Cleaning package cache..."
apt autoremove -y && apt autoclean || log_warn "Failed to clean package cache"

log_info "Productivity tools installation complete!"