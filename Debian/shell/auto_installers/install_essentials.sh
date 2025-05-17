#!/bin/bash

# Installs essential applications for Debian/Ubuntu (browsers, file managers, etc.)
# Run with sudo: sudo bash install_essentials_debian.sh

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

read -p "Install essential applications (browsers, file managers, etc.)? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_error "Script execution cancelled"
fi

log_info "Updating system..."
apt update && apt upgrade -y || log_error "Failed to update system"

log_info "Installing required tools..."
apt install -y curl wget apt-transport-https software-properties-common || log_error "Failed to install required tools"

log_info "Installing essential applications..."
apt install -y \
    wget curl rsync \
    zip unzip \
    tar gzip bzip2 xz-utils lzop zstd \
    p7zip-full unrar \
    jq yq \
    dnsutils \
    eog nautilus \
    terminator tree \
    vim neovim \
    neofetch tmux \
    network-manager || log_error "Failed to install essential applications"

log_info "Installing Brave browser..."
curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.asc | gpg --dearmor -o /usr/share/keyrings/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list
apt update && apt install -y brave-browser || log_error "Failed to install Brave"

log_info "Cleaning package cache..."
apt autoremove -y && apt autoclean || log_warn "Failed to clean package cache"

log_info "Essentials installation complete!"