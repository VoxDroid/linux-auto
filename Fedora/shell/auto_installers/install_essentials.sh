#!/bin/bash

# Installs essential applications for Fedora/RHEL-based systems (browsers, file managers, etc.)
# Run with sudo: sudo bash install_essentials_fedora.sh

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
dnf update -y || log_error "Failed to update system"

log_info "Installing required tools..."
dnf install -y curl wget || log_error "Failed to install required tools"

log_info "Installing essential applications..."
dnf install -y \
    wget curl rsync \
    zip unzip \
    tar gzip bzip2 xz lzop zstd \
    p7zip p7zip-plugins \
    jq yq \
    bind-utils \
    eog nautilus \
    terminator tree \
    vim neovim \
    fastfetch tmux \
    NetworkManager || log_error "Failed to install essential applications"

log_info "Installing Brave browser..."
dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
dnf install -y brave-browser || log_error "Failed to install Brave"

log_info "Cleaning package cache..."
dnf autoremove -y && dnf clean all || log_warn "Failed to clean package cache"

log_info "Essentials installation complete!"