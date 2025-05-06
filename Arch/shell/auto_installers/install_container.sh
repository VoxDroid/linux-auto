#!/bin/bash

# Installs containerization tools for Arch Linux (Docker, Podman, etc.)
# Run with sudo: sudo bash install_containerization.sh

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

read -p "Install containerization tools (Docker, Podman, etc.)? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_error "Script execution cancelled"
fi

log_info "Updating system..."
pacman -Syu --noconfirm || log_error "Failed to update system"

log_info "Installing containerization tools..."
pacman -S --needed --noconfirm \
    docker docker-compose podman buildah || log_error "Failed to install containerization tools"

systemctl start --now docker || log_warn "Failed to start Docker"
systemctl enable --now docker || log_warn "Failed to enable Docker"

log_info "Cleaning package cache..."
paccache -r || log_warn "Failed to clean package cache"

log_info "Containerization tools installation complete! Add user to docker group: 'sudo usermod -aG docker $SUDO_USER'."