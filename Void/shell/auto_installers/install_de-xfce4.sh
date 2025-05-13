#!/bin/bash

# Installs XFCE desktop environment and enhancements for Void Linux
# Includes core XFCE, utilities, themes, LightDM, and xfce4-docklike-plugin, xfce4-weather-plugin, xfce4-whiskermenu-plugin
# Automatically compiles plugins from source if not found in Flatpak
# Run with sudo: sudo bash install_de-xfce4_void.sh

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

read -p "Install XFCE desktop environment and enhancements (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_error "Script execution cancelled"
fi

log_info "Updating system..."
xbps-install -Su || log_error "Failed to update system"

log_info "Installing XFCE desktop environment and core components..."
xbps-install -S --yes \
    xfce4 xfce4-panel xfce4-settings xfce4-terminal \
    xfce4-power-manager xfce4-notifyd xfce4-screenshooter \
    xfce4-taskmanager xfce4-appfinder xfce4-pulseaudio-plugin \
    Thunar thunar-archive-plugin thunar-media-tags-plugin \
    papirus-icon-theme || log_error "Failed to install XFCE packages"

log_info "Installing LightDM display manager and greeter..."
xbps-install -S --yes \
    lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings || log_error "Failed to install LightDM packages"

log_info "Setting up Flatpak for additional XFCE plugins..."
if ! command -v flatpak &>/dev/null; then
    log_info "Installing Flatpak..."
    xbps-install -S --yes flatpak || log_error "Failed to install Flatpak"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || log_error "Failed to add Flathub repo"
else
    log_info "Flatpak is already installed"
fi

log_info "Installing build dependencies for compiling XFCE plugins..."
xbps-install -S --yes \
    git make gcc pkg-config autoconf automake libtool \
    xfce4-dev-tools libxfce4ui-devel \
    gtk+3-devel glib-devel || log_error "Failed to install build dependencies"

# Define plugins and their GitLab URLs
declare -A plugins=(
    ["xfce4-docklike-plugin"]="https://gitlab.xfce.org/panel-plugins/xfce4-docklike-plugin"
    ["xfce4-weather-plugin"]="https://gitlab.xfce.org/panel-plugins/xfce4-weather-plugin"
    ["xfce4-whiskermenu-plugin"]="https://gitlab.xfce.org/panel-plugins/xfce4-whiskermenu-plugin"
)

log_info "Attempting to install XFCE plugins (docklike, weather, whiskermenu)..."
for plugin in "${!plugins[@]}"; do
    # First, try Flatpak
    search_result=$(flatpak search "$plugin" | grep -i "$plugin" || true)
    if [[ -n "$search_result" ]]; then
        app_id=$(echo "$search_result" | awk '{print $1}' | head -n 1)
        log_info "Found $plugin in Flathub as $app_id. Installing..."
        sudo -u "$SUDO_USER" flatpak install -y flathub "$app_id" || log_warn "Failed to install $plugin from Flathub"
    else
        log_info "$plugin not found in Flathub. Compiling from source..."
        # Compile from source
        build_dir="/tmp/$plugin"
        rm -rf "$build_dir"
        sudo -u "$SUDO_USER" bash -c "
            git clone ${plugins[$plugin]} $build_dir || exit 1
            cd $build_dir
            ./autogen.sh || exit 1
            make || exit 1
            sudo make install || exit 1
        " && log_info "$plugin compiled and installed successfully" || {
            log_warn "Failed to compile/install $plugin. Continuing with other installations."
            continue
        }
        rm -rf "$build_dir"
    fi
done

log_info "Enabling LightDM display manager..."
ln -sf /etc/sv/lightdm /var/service/ || log_warn "Failed to enable LightDM"

log_info "Cleaning package cache..."
xbps-remove -O || log_warn "Failed to clean package cache"

log_info "XFCE desktop environment installation complete!"
log_info "Configure LightDM and XFCE themes via XFCE Settings Manager."
log_info "If any plugins failed to install, check warnings above for details."