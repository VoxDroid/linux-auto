#!/bin/bash

# Installs a comprehensive GNOME desktop environment for Fedora/RHEL-based systems
# Includes gnome, gnome-core, utilities, themes, and optional tools
# Uses GDM as the display manager
# Run with sudo: sudo bash install_gnome_fedora.sh

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

read -p "Install comprehensive GNOME desktop environment (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_error "Script execution cancelled"
fi

log_info "Updating system..."
dnf update -y || log_error "Failed to update system"

log_info "Installing required tools..."
dnf install -y curl wget || log_error "Failed to install required tools"

log_info "Installing GNOME desktop environment..."
dnf install -y \
    gnome-tweaks gnome-shell-extension-common gnome-control-center \
    gnome-system-monitor gnome-disk-utility gnome-keyring \
    gnome-backgrounds adwaita-icon-theme \
    nautilus gnome-terminal gnome-screenshot \
    eog evince file-roller gedit totem \
    orca \
    gnome-remote-desktop || log_error "Failed to install GNOME packages"

log_info "Installing additional GNOME themes and utilities..."
dnf install -y \
    papirus-icon-theme arc-theme \
    gnome-shell-extension-manager || log_error "Failed to install additional themes and utilities"

log_info "Installing AppIndicator extension..."
dnf install -y gnome-shell-extension-appindicator || log_error "Failed to install GNOME extensions"

log_info "Enabling GDM display manager..."
systemctl enable gdm || log_warn "Failed to enable GDM"

log_info "Cleaning package cache..."
dnf autoremove -y && dnf clean all || log_warn "Failed to clean package cache"

log_info "GNOME desktop environment installation complete! Configure GNOME settings via Settings or GNOME Tweaks."