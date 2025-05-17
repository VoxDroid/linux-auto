#!/bin/bash

# Installs communication apps for Debian/Ubuntu (Thunderbird, Pidgin, Discord, Slack, etc.)
# Run with sudo: sudo bash install_communication_debian.sh

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

read -p "Install communication apps (Thunderbird, Pidgin, Discord, Slack, etc.)? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_error "Script execution cancelled"
fi

log_info "Updating system..."
apt update && apt upgrade -y || log_error "Failed to update system"

log_info "Installing required tools..."
apt install -y curl wget apt-transport-https snapd || log_error "Failed to install required tools"

log_info "Ensuring Snap is enabled..."
systemctl enable --now snapd.socket || log_warn "Failed to enable snapd socket"
ln -sf /var/lib/snapd/snap /snap || log_warn "Failed to create snap symlink"

log_info "Installing communication apps from apt..."
apt install -y thunderbird pidgin hexchat || log_error "Failed to install communication apps from apt"

log_info "Installing Discord via Snap..."
snap install discord || log_error "Failed to install Discord"

log_info "Installing Slack via Snap..."
snap install slack || log_error "Failed to install Slack"

log_info "Installing Telegram via Snap..."
snap install telegram-desktop || log_error "Failed to install Telegram"

log_info "Cleaning package cache..."
apt autoremove -y && apt autoclean || log_warn "Failed to clean package cache"

log_info "Communication apps installation complete!"