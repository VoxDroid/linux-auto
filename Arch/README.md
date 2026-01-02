# Arch Linux Automation Scripts

## Overview

This directory contains automated installation scripts specifically designed for Arch Linux systems. These scripts leverage the pacman package manager and AUR (Arch User Repository) to install software packages, development tools, and system utilities. The scripts are optimized for Arch Linux's rolling release model and focus on providing a comprehensive setup for development environments, productivity tools, and system administration tasks.

## Prerequisites

- Arch Linux installation
- Root or sudo access
- Internet connection
- pacman package manager (included by default)
- yay or another AUR helper (recommended for AUR packages)

## Available Scripts

The following automated installation scripts are available in the `shell/auto_installers/` directory:

### Core System Scripts
- `install_essentials.sh` - Installs core system utilities, basic tools, and essential packages
- `install_shell.sh` - Enhances shell environment with improved utilities and configurations
- `install_fonts-locale.sh` - Installs additional fonts and configures system locales

### Development Tools
- `install_devtools.sh` - Compilers, build tools, IDEs, and development environments
- `install_proglang.sh` - Programming language runtimes and SDKs (Python, Java, Node.js, etc.)
- `install_vcs.sh` - Version control systems (Git, Mercurial, etc.)
- `install_pymodules.sh` - Python packages and libraries via pip

### Desktop and User Interface
- `install_de-gnome.sh` - GNOME desktop environment and related tools
- `install_de-plasmakde.sh` - KDE Plasma desktop environment
- `install_de-xfce4.sh` - XFCE4 lightweight desktop environment
- `install_theme-nordicdarker.sh` - Nordic Darker theme for consistent appearance

### Productivity and Applications
- `install_productivity.sh` - Office suites, document editors, and productivity tools
- `install_media.sh` - Multimedia applications, codecs, and media tools
- `install_coms.sh` - Communication and collaboration tools (email, chat, etc.)

### System Administration
- `install_databases.sh` - Database servers and clients (MySQL, PostgreSQL, etc.)
- `install_container.sh` - Container runtimes (Docker, Podman) and orchestration tools
- `install_virt.sh` - Virtualization platforms (VirtualBox, QEMU, etc.)
- `install_backuptools.sh` - Backup and recovery utilities
- `install_diskutil.sh` - Disk management and partitioning tools
- `install_filesyscompat.sh` - File system support and compatibility tools
- `install_drivers.sh` - Hardware drivers and firmware packages

### Security and Monitoring
- `install_netsec.sh` - Network security tools and firewalls
- `install_monitoring.sh` - System monitoring, logging, and diagnostic tools

### Specialized Tools
- `install_gamedev.sh` - Game development tools and engines
- `install_reveng.sh` - Reverse engineering and analysis tools

## System Scripts

Additional system maintenance scripts are available in the `shell/system_scripts/` directory:

- `all_locales.sh` - Generates and configures all available system locales

## Usage

### Running Installation Scripts

1. Navigate to the Arch directory:
   ```bash
   cd Arch/
   ```

2. Make the desired script executable:
   ```bash
   chmod +x shell/auto_installers/install_essentials.sh
   ```

3. Run the script with appropriate privileges:
   ```bash
   sudo ./shell/auto_installers/install_essentials.sh
   ```

### Running System Scripts

1. Navigate to the system scripts directory:
   ```bash
   cd shell/system_scripts/
   ```

2. Make the script executable and run:
   ```bash
   chmod +x all_locales.sh
   sudo ./all_locales.sh
   ```

## Package Manager Notes

- Scripts use `pacman` for official repository packages
- Some scripts may use `yay` or other AUR helpers for community packages
- Ensure your system is up to date: `sudo pacman -Syu`
- Scripts handle dependency resolution automatically

## Customization

Scripts can be modified to:
- Add or remove specific packages
- Change installation options
- Include custom configurations
- Adapt to different Arch-based distributions (Manjaro, EndeavourOS, etc.)

## Troubleshooting

- **Permission Issues**: Ensure running with sudo
- **Package Conflicts**: Review pacman output for conflicts
- **AUR Packages**: Ensure AUR helper is installed and configured
- **Network Issues**: Check mirrorlist and internet connectivity

## Contributing

When contributing Arch-specific scripts:
- Test on latest Arch Linux
- Include AUR package handling where appropriate
- Document any special requirements
- Follow existing script structure and error handling