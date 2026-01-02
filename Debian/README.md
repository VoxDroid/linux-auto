# Debian/Ubuntu Automation Scripts

## Overview

This directory contains automated installation scripts designed for Debian-based Linux distributions, including Debian, Ubuntu, and their derivatives. These scripts utilize the apt package manager to install software packages, development tools, and system utilities. The scripts are optimized for Debian's stable release model and focus on providing reliable, tested software installations.

## Prerequisites

- Debian-based Linux distribution (Debian, Ubuntu, Linux Mint, etc.)
- Root or sudo access
- Internet connection
- apt package manager (included by default)

## Available Scripts

The following automated installation scripts are available in the `shell/auto_installers/` directory:

### Core System Scripts
- `install_essentials.sh` - Installs core system utilities, basic tools, and essential packages
- `install_shell.sh` - Enhances shell environment with improved utilities and configurations
- `install_fonts-locale.sh` - Installs additional fonts and configures system locales

### Desktop and User Interface
- `install_de-gnome.sh` - GNOME desktop environment and related tools
- `install_theme-nordicdarker.sh` - Nordic Darker theme for consistent appearance

### Productivity and Applications
- `install_productivity.sh` - Office suites, document editors, and productivity tools
- `install_media.sh` - Multimedia applications, codecs, and media tools
- `install_coms.sh` - Communication and collaboration tools (email, chat, etc.)

## Usage

### Running Installation Scripts

1. Navigate to the Debian directory:
   ```bash
   cd Debian/
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

- Scripts use `apt` for package management
- Automatic updates of package lists: `sudo apt update`
- Scripts handle dependency resolution automatically
- Compatible with Debian stable, testing, and Ubuntu LTS releases

## Customization

Scripts can be modified to:
- Add or remove specific packages
- Change installation options
- Include custom repositories (PPA for Ubuntu)
- Adapt to different Debian derivatives

## Troubleshooting

- **Permission Issues**: Ensure running with sudo
- **Package Conflicts**: Review apt output for conflicts
- **Repository Issues**: Check sources.list configuration
- **Network Issues**: Verify internet connectivity and proxy settings

## Contributing

When contributing Debian/Ubuntu-specific scripts:
- Test on multiple Debian versions and Ubuntu releases
- Include PPA handling where appropriate for Ubuntu
- Document any special repository requirements
- Follow existing script structure and error handling