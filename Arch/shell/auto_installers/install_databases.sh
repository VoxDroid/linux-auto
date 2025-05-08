#!/bin/bash

# Installs databases for Arch Linux (PostgreSQL, MariaDB, MongoDB, etc.)
# Run with sudo: sudo bash install_databases.sh

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

read -p "Install databases (PostgreSQL, MariaDB, etc.)? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_error "Script execution cancelled"
fi

log_info "Updating system..."
pacman -Syu --noconfirm || log_error "Failed to update system"

if ! command -v yay &>/dev/null; then
    log_info "Installing Yay AUR helper..."
    pacman -S --needed --noconfirm base-devel git || log_error "Failed to install base-devel and git"
        sudo -u "$SUDO_USER" bash -c '
        cd /tmp
        git clone https://aur.archlinux.org/yay.git || exit 1
        cd yay
        makepkg -si --noconfirm || exit 1
    '
    rm -rf /tmp/yay
else
    log_info "Yay is already installed"
fi

log_info "Installing databases..."
pacman -S --needed --noconfirm \
    postgresql mariadb sqlite mysql-workbench \
    redis memcached || log_error "Failed to install databases"

log_info "Installing MongoDB..."
sudo -u "$SUDO_USER" yay -S --needed --noconfirm mongodb-bin || log_error "Failed to install MongoDB"

log_info "Initializing and enabling databases..."
if ! systemctl is-active --quiet postgresql; then
    su - postgres -c "initdb --locale en_US.UTF-8 -D '/var/lib/postgres/data'" || log_warn "Failed to initialize PostgreSQL"
    systemctl enable --now postgresql || log_warn "Failed to enable PostgreSQL"
fi
if ! systemctl is-active --quiet mariadb; then
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql || log_warn "Failed to initialize MariaDB"
    systemctl enable --now mariadb || log_warn "Failed to enable MariaDB"
fi
systemctl enable --now redis || log_warn "Failed to enable Redis"

log_info "Cleaning package cache..."
paccache -r || log_warn "Failed to clean package cache"

log_info "Databases installation complete! Configure users/passwords as needed."