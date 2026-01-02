# Fedora/Red Hat Automation Scripts

## Overview

This directory contains automated installation scripts designed for Fedora and Red Hat-based Linux distributions. These scripts utilize the dnf package manager (and legacy yum compatibility) to install software packages, development tools, and system utilities. The scripts are optimized for Fedora's release cycle and focus on providing modern, up-to-date software installations.

## Prerequisites

- Fedora or Red Hat-based Linux distribution (RHEL, CentOS, etc.)
- Root or sudo access
- Internet connection
- dnf package manager (included by default in Fedora)

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

1. Navigate to the Fedora directory:
   ```bash
   cd Fedora/
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

- Scripts use `dnf` for package management (Fedora's primary package manager)
- Backward compatible with `yum` commands where needed
- Automatic updates of package metadata: `sudo dnf check-update`
- Scripts handle dependency resolution automatically
- RPM Fusion and other third-party repositories may be utilized

## Customization

Scripts can be modified to:
- Add or remove specific packages
- Change installation options
- Include custom repositories (RPM Fusion, COPR, etc.)
- Adapt to different Red Hat derivatives

## Troubleshooting

- **Permission Issues**: Ensure running with sudo
- **Package Conflicts**: Review dnf output for conflicts
- **Repository Issues**: Check dnf configuration and repository files
- **Network Issues**: Verify internet connectivity and proxy settings

## Contributing

When contributing Fedora/Red Hat-specific scripts:
- Test on latest Fedora releases and RHEL versions
- Include RPM Fusion or COPR repository handling where appropriate
- Document any special repository requirements
- Follow existing script structure and error handling