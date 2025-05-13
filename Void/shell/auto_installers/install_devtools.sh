#!/bin/bash

# Installs development tools for Void Linux (compilers, debuggers, IDEs)
# Includes gcc, clang, make, cmake, gdb, valgrind, cppcheck, jq, yq, vscode, autoconf, automake
# Run with sudo: sudo bash install_dev_tools_void.sh

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

read -p "Install development tools (compilers, IDEs, etc.)? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_error "Script execution cancelled"
fi

log_info "Updating system..."
xbps-install -Su || log_error "Failed to update system"

log_info "Installing development tools..."
xbps-install -S --yes \
    gcc clang make cmake gdb valgrind cppcheck \
    jq yq autoconf automake || log_error "Failed to install development tools"

log_info "Setting up Flatpak for Visual Studio Code..."
if ! command -v flatpak &>/dev/null; then
    log_info "Installing Flatpak..."
    xbps-install -S --yes flatpak || log_error "Failed to install Flatpak"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || log_error "Failed to add Flathub repo"
else
    log_info "Flatpak is already installed"
fi

log_info "Installing Visual Studio Code via Flatpak..."
sudo -u "$SUDO_USER" flatpak install -y flathub com.visualstudio.code || log_error "Failed to install Visual Studio Code"

log_info "Cleaning package cache..."
xbps-remove -O || log_warn "Failed to clean package cache"

log_info "Development tools installation complete!"