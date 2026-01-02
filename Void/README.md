# Void Linux Automation Scripts

## Overview

This directory contains automated installation scripts designed specifically for Void Linux. These scripts utilize the xbps package manager to install software packages, development tools, and system utilities. The scripts are optimized for Void Linux's unique approach to package management and focus on providing a streamlined setup for development environments and productivity tools.

## Prerequisites

- Void Linux installation
- Root or sudo access
- Internet connection
- xbps package manager (included by default)

## Available Scripts

The following automated installation scripts are available in the `shell/auto_installers/` directory:

### Core System Scripts
- `install_essentials.sh` - Installs core system utilities, basic tools, and essential packages
- `install_shell.sh` - Enhances shell environment with improved utilities and configurations
- `install_fonts-locale.sh` - Installs additional fonts and configures system locales

### Development Tools
- `install_devtools.sh` - Compilers, build tools, IDEs, and development environments

### Desktop and User Interface
- `install_de-xfce4.sh` - XFCE4 lightweight desktop environment
- `install_theme-nordicdarker.sh` - Nordic Darker theme for consistent appearance

### Productivity and Applications
- `install_libreoffice.sh` - LibreOffice productivity suite

## Usage

### Running Installation Scripts

1. Navigate to the Void directory:
   ```bash
   cd Void/
   ```

2. Make the desired script executable:
   ```bash
   chmod +x shell/auto_installers/install_essentials.sh
   ```

3. Run the script with appropriate privileges:
   ```bash
   sudo ./shell/auto_installers/install_essentials.sh
   ```

## Package Manager Notes

- Scripts use `xbps` for package management (Void Linux's native package manager)
- Automatic updates of package databases: `sudo xbps-install -S`
- Scripts handle dependency resolution automatically
- Compatible with both glibc and musl libc variants of Void Linux

## Customization

Scripts can be modified to:
- Add or remove specific packages
- Change installation options
- Include custom repositories or overlays
- Adapt to glibc vs musl libc environments

## Troubleshooting

- **Permission Issues**: Ensure running with sudo
- **Package Conflicts**: Review xbps output for conflicts
- **Repository Issues**: Check xbps configuration and repository settings
- **Network Issues**: Verify internet connectivity and proxy settings

## Contributing

When contributing Void Linux-specific scripts:
- Test on both glibc and musl libc variants
- Include any special Void-specific package handling
- Document any unique requirements or considerations
- Follow existing script structure and error handling