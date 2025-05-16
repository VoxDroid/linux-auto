#!/bin/bash

# Installs shell enhancements for Arch Linux (Zsh, Fish, Powerline, Oh My Zsh, Powerlevel10k, etc.)
# Run with sudo: sudo bash install_shell_enhancements.sh

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

read -p "Install shell enhancements (Zsh, Fish, Oh My Zsh, Powerlevel10k, etc.)? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_error "Script execution cancelled"
fi

log_info "Updating system..."
pacman -Syu --noconfirm || log_error "Failed to update system"

log_info "Installing pacman-contrib..."
pacman -S --needed --noconfirm pacman-contrib || log_error "Failed to install pacman-contrib"

log_info "Installing shell enhancements..."
pacman -S --needed --noconfirm \
    zsh fish zsh-autosuggestions zsh-completions zsh-syntax-highlighting \
    powerline powerline-fonts tmux curl git || log_error "Failed to install shell enhancements"

log_info "Cleaning package cache..."
paccache -r || log_warn "Failed to clean package cache"

log_info "Installing Oh My Zsh for user $SUDO_USER..."
if [[ -d "/home/$SUDO_USER/.oh-my-zsh" ]]; then
    log_info "Oh My Zsh already installed, skipping..."
else
    su - "$SUDO_USER" -c "sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" --unattended" || log_error "Failed to install Oh My Zsh"
fi

log_info "Installing Powerlevel10k for user $SUDO_USER..."
if [[ -d "/home/$SUDO_USER/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then
    log_info "Powerlevel10k already installed, skipping..."
else
    su - "$SUDO_USER" -c "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/$SUDO_USER/.oh-my-zsh/custom/themes/powerlevel10k" || log_error "Failed to install Powerlevel10k"
    su - "$SUDO_USER" -c "sed -i 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/g' /home/$SUDO_USER/.zshrc" || log_warn "Failed to set Powerlevel10k theme"
fi

log_info "Enabling Zsh plugins for user $SUDO_USER..."
su - "$SUDO_USER" -c "echo 'source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' >> /home/$SUDO_USER/.zshrc" || log_warn "Failed to enable zsh-autosuggestions"
su - "$SUDO_USER" -c "echo 'source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> /home/$SUDO_USER/.zshrc" || log_warn "Failed to enable zsh-syntax-highlighting"
su - "$SUDO_USER" -c "echo 'fpath=(/usr/share/zsh/site-functions /usr/share/zsh/functions/Completion/* \$fpath)' >> /home/$SUDO_USER/.zshrc" || log_warn "Failed to enable zsh-completions"

log_info "Shell enhancements, Oh My Zsh, and Powerlevel10k installation complete!"
log_info "Run 'chsh -s /usr/bin/zsh' or 'chsh -s /usr/bin/fish' to switch shells."
log_info "Powerlevel10k is set as the Zsh theme with completions enabled. Run 'p10k configure' to customize it."