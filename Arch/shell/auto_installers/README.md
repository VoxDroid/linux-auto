# Arch Linux Setup Scripts

This repository contains 18 shell scripts to automate the setup of a comprehensive Arch Linux environment for development, programming, databases, productivity, containerization, and more. Each script is standalone, uses `pacman` for system packages and `yay` for AUR packages, and includes error handling and user confirmation.

## Prerequisites
- Arch Linux system with `pacman` configured.
- Internet connection for package downloads.
- Sufficient disk space (10-20 GB recommended for full setup).
- Run all scripts with `sudo` to handle system package installations and service configurations.
- A non-root user with `sudo` privileges (used for AUR installations via `yay`).

## Important Notes
- **Yay and AUR**: Scripts use `yay` for AUR packages, executed as the non-root user who invoked `sudo` (via `sudo -u $SUDO_USER`). Ensure `base-devel` and `git` are installed.
- **Sudo Requirement**: Scripts require `sudo` for `pacman` and service management, but AUR installations are handled as non-root.
- **Disk Space**: Full setup may require 10-20 GB, especially with locale generation.
- **Backup**: Back up critical files (e.g., `/etc/locale.gen`) before running.
- **Reboot**: Recommended after running scripts to apply settings.

## Scripts Overview

### 1. install_essentials.sh
- **Purpose**: Installs essential applications (browsers, Gwenview, file managers).
- **Packages**: Firefox, Chromium, Brave (AUR), Tor Browser, Gwenview, Dolphin, Terminator, Tree, Neofetch.
- **Installation**:
  ```bash
  chmod +x install_essentials.sh
  sudo ./install_essentials.sh
  ```
- **Notes**: Gwenview is the recommended KDE image viewer. Brave is installed via AUR.

### 2. install_devtools.sh
- **Purpose**: Installs development tools (compilers, IDEs, version control).
- **Packages**: GCC, Clang, CMake, GDB, Valgrind, VSCodium, Eclipse, IntelliJ IDEA (AUR), PyCharm (AUR), Visual Studio Code (AUR), Eclipse Java Bin (AUR), Git, JQ, YQ, Pytest, Black, Flake8, Shellcheck, ESLint, Prettier.
- **Installation**:
  ```bash
  chmod +x install_dev_tools.sh
  sudo ./install_dev_tools.sh
  ```
- **Notes**: AUR IDEs are installed as the non-root user.

### 3. install_proglang.sh
- **Purpose**: Installs programming languages.
- **Packages**: Python, Node.js, Java, Go, Rust, Ruby, PHP, Perl, Haskell, Lua, Kotlin, Scala, Erlang, Elixir, and their build tools.
- **Installation**:
  ```bash
  chmod +x install_languages.sh
  sudo ./install_languages.sh
  ```

### 4. install_databases.sh
- **Purpose**: Installs and configures databases.
- **Packages**: PostgreSQL, MariaDB, SQLite, MongoDB (AUR), Redis, Memcached, MySQL Workbench.
- **Installation**:
  ```bash
  chmod +x install_databases.sh
  sudo ./install_databases.sh
  ```
- **Post-Installation**:
  - Configure PostgreSQL: `sudo -u postgres psql`
  - Secure MariaDB: `sudo mysql_secure_installation`
  - Check services: `systemctl status postgresql mariadb redis`

### 5. install_productivity.sh
- **Purpose**: Installs office suites and note-taking tools.
- **Packages**: LibreOffice, Okular, OnlyOffice (AUR), Notion (AUR), Obsidian (AUR), Evince, Zathura.
- **Installation**:
  ```bash
  chmod +x install_productivity.sh
  sudo ./install_productivity.sh
  ```

### 6. install_coms.sh
- **Purpose**: Installs communication apps.
- **Packages**: Thunderbird, Pidgin, HexChat, Discord (AUR), Slack (AUR), Telegram (AUR).
- **Installation**:
  ```bash
  chmod +x install_communication.sh
  sudo ./install_communication.sh
  ```

### 7. install_media.sh
- **Purpose**: Installs media editing and playback tools.
- **Packages**: GIMP, VLC, Flameshot, Kolourpaint, Audacity, Kdenlive.
- **Installation**:
  ```bash
  chmod +x install_media.sh
  sudo ./install_media.sh
  ```

### 8. install_virt.sh
- **Purpose**: Installs virtualization tools.
- **Packages**: QEMU, Virt-Manager, Vagrant.
- **Installation**:
  ```bash
  chmod +x install_virtualization.sh
  sudo ./install_virtualization.sh
  ```
- **Post-Installation**: Check service: `systemctl status libvirtd`

### 9. install_netsec.sh
- **Purpose**: Installs network and security tools.
- **Packages**: NetworkManager, Nmap, Wireshark, Bind, Metasploit, OpenVPN.
- **Installation**:
  ```bash
  chmod +x install_network_security.sh
  sudo ./install_network_security.sh
  ```
- **Post-Installation**: Enable NetworkManager: `systemctl status NetworkManager`

### 10. install_pymodules.sh
- **Purpose**: Installs machine learning and data science tools.
- **Packages**: NumPy, Pandas, Scikit-learn, Matplotlib, JupyterLab, TensorFlow (AUR).
- **Installation**:
  ```bash
  chmod +x install_ml_data_science.sh
  sudo ./install_ml_data_science.sh
  ```

### 11. install_gamedev.sh
- **Purpose**: Installs game development tools.
- **Packages**: Godot, Blender, UnityHub.
- **Installation**:
  ```bash
  chmod +x install_game_dev.sh
  sudo ./install_game_dev.sh
  ```

### 12. install_reveng.sh
- **Purpose**: Installs reverse engineering and forensic tools.
- **Packages**: Ghidra, Radare2, Binwalk.
- **Installation**:
  ```bash
  chmod +x install_reverse_engineering.sh
  sudo ./install_reverse_engineering.sh
  ```

### 13. install_fonts-locales.sh
- **Purpose**: Installs fonts and generates all locales.
- **Packages**: Noto Fonts (including CJK), Adobe Source Fonts, Amiri, and more.
- **Installation**:
  ```bash
  chmod +x install_fonts_locales.sh
  sudo ./install_fonts_locales.sh
  ```
- **Notes**: Uses regex to uncomment all locales in `/etc/locale.gen`. May take significant time and space.

### 14. install_shell.sh
- **Purpose**: Installs shell enhancements.
- **Packages**: Zsh, Fish, Powerline, Tmux, and Zsh plugins.
- **Installation**:
  ```bash
  chmod +x install_shell_enhancements.sh
  sudo ./install_shell_enhancements.sh
  ```
- **Post-Installation**: Switch shells: `chsh -s /usr/bin/zsh` or `chsh -s /usr/bin/fish`

### 15. install_container.sh
- **Purpose**: Installs containerization tools.
- **Packages**: Docker, Docker Compose, Podman, Buildah.
- **Installation**:
  ```bash
  chmod +x install_containerization.sh
  sudo ./install_containerization.sh
  ```
- **Post-Installation**:
  - Add user to Docker group: `sudo usermod -aG docker $USER`
  - Check service: `systemctl status docker`

### 16. install_monitoring.sh
- **Purpose**: Installs system monitoring tools.
- **Packages**: htop, btop, Glances, Nagios.
- **Installation**:
  ```bash
  chmod +x install_system_monitoring.sh
  sudo ./install_system_monitoring.sh
  ```

### 17. install_backuptools.sh
- **Purpose**: Installs backup tools.
- **Packages**: rsync, Restic, Timeshift (AUR).
- **Installation**:
  ```bash
  chmod +x install_backup_tools.sh
  sudo ./install_backup_tools.sh
  ```
- **Post-Installation**: Configure Timeshift for snapshots.

### 18. install_de-plasmakde.sh
- **Purpose**: Installs KDE desktop enhancements.
- **Packages**: Plasma Desktop, Plasma PA, Plasma NM, KDE Plasma Addons, Latte Dock, SDDM Theme (AUR).
- **Installation**:
  ```bash
  chmod +x install_de-plasmakde.sh
  sudo ./install_de-plasmakde.sh
  ```
- **Post-Installation**: Configure SDDM themes via system settings.

### 19. install_filesystem_compatibility.sh
- **Purpose**: Installs filesystem compatibility tools for Arch Linux.
- **Packages**: ntfs-3g, exfat-utils, dosfstools, mtools, fuse2, fuse3, cifs-utils, btrfs-progs, xfsprogs, f2fs-tools, udftools, nfs-utils, smbclient, e2fsprogs, nilfs-utils, jfsutils, reiserfsprogs, zfs-utils, hfsprogs (AUR).
- **Installation**:
  ```bash
  chmod +x install_filesystem_compatibility.sh
  sudo ./install_filesystem_compatibility.sh
  ```
- **Post-Installation**: Configure mount points for non-native filesystems (e.g., NTFS, exFAT) in `/etc/fstab` if needed. For ZFS, ensure the ZFS kernel module is installed and enabled.

### 20. install_drivers.sh
- **Purpose**: Installs driver-related packages for Arch Linux.
- **Packages**: linux-firmware, mesa, lib32-mesa, vulkan-intel, vulkan-radeon, lib32-vulkan-intel, lib32-vulkan-radeon, libva-intel-driver, libva-mesa-driver, xf86-video-amdgpu, xf86-video-intel, nvidia, nvidia-utils, lib32-nvidia-utils, amd-ucode, intel-ucode, libvdpau, lib32-libvdpau, bluez, bluez-utils, sof-firmware, fwupd, broadcom-wl (AUR).
- **Installation**:
  ```bash
  chmod +x install_drivers.sh
  sudo ./install_drivers.sh
  ```
- **Post-Installation**: Reboot to ensure drivers (e.g., NVIDIA, Broadcom) are loaded. Update microcode with `sudo grub-mkconfig -o /boot/grub/grub.cfg` if using GRUB. Enable `bluetooth.service` for Bluetooth support.

### 21. install_diskutil.sh
- **Purpose**: Installs disk utility tools for Arch Linux.
- **Packages**: parted, gparted, gptfdisk, lvm2, cryptsetup, smartmontools, hdparm, nvme-cli, testdisk, wipe, partimage, dar, mdadm, dmraid, fatresize.
- **Installation**:
  ```bash
  chmod +x install_diskutil.sh
  sudo ./install_diskutil.sh
  ```
- **Post-Installation**: Use `smartctl` to check disk health (e.g., `sudo smartctl -a /dev/sda`). Configure LVM or RAID setups if required. Ensure `cryptsetup` is set up for encrypted partitions.

### 22. install_vcs.sh
- **Purpose**: Installs version control systems and related tools for Arch Linux.
- **Packages**: git, mercurial, subversion, bazaar, cvs, git-lfs, tig, meld, kdiff3, github-desktop-bin (via Yay AUR helper).
- **Installation**:
  ```bash
  chmod +x install_vcs.sh
  sudo ./install_vcs.sh
  ```
- **Post-Installation**: Configure Git with `git config --global user.name "Your Name"` and `git config --global user.email "your.email@example.com"`. Use `meld` or `kdiff3` for visual diff and merge operations. Launch GitHub Desktop with `github-desktop` for GUI-based Git management.

### 23. install_de-gnome.sh
- **Purpose**: Installs a comprehensive GNOME desktop environment.
- **Packages**: GNOME, GNOME Core, GDM, GNOME Tweaks, GNOME Shell Extensions, Nautilus, GNOME Terminal, Papirus Icon Theme, Arc GTK Theme, Dash to Dock (AUR), AppIndicator (AUR).
- **Installation**:
  ```bash
  chmod +x install_de-gnome.sh
  sudo ./install_de-gnome.sh
  ```
- **Post-Installation**: Configure GNOME settings and extensions via Settings or GNOME Tweaks.

### 24. install_de-xfce4.sh
- **Purpose**: Installs a comprehensive XFCE desktop environment with a lightweight and customizable setup.
- **Packages**: XFCE4, XFCE4 Goodies, LightDM, LightDM GTK Greeter, XFCE Panel, XFCE Settings, XFCE Terminal, Thunar, XFCE Power Manager, XFCE Notifyd, XFCE Screenshooter, Greybird GTK Theme, Arc GTK Theme, Papirus Icon Theme, XFCE Docklike Plugin (AUR), XFCE Weather Plugin (AUR), XFCE WhiskerMenu Plugin (AUR).
- **Installation**:
  ```bash
  chmod +x install_de-xfce4.sh
  sudo ./install_de-xfce4.sh
  ```
- **Post-Installation**: Configure XFCE settings and themes via XFCE Settings Manager or LightDM GTK Greeter Settings.

### 25. install_theme-nordicdarker.sh
- **Purpose**: Installs Nordic Darker GTK themes and Nordic folder icons for a cohesive, dark-themed desktop experience.
- **Packages**: Nordic Darker GTK themes (Nordic-darker, Nordic-darker-v40), Nordic folder icons (cloned from Nordic repository, kde/folders/*), dependencies (xz, tar, wget, git).
- **Installation**:
  ```bash
  chmod +x install_theme-nordicdarker.sh
  sudo ./install_theme-nordicdarker.sh
  ```
- **Post-Installation**: Configure GTK themes and icon themes via your desktop environment’s settings (e.g., LXAppearance for XFCE, System Settings for KDE).

## Troubleshooting
- **Yay Errors**: Ensure `base-devel` and `git` are installed (`sudo pacman -S base-devel git`). Run `yay -Syu` as the non-root user to update AUR packages.
- **Makepkg as Root**: Scripts use `sudo -u $SUDO_USER` to avoid this. Verify `$SUDO_USER` is set (`echo $SUDO_USER`).
- **AUR Build Failures**: Run `yay -S <package>` manually (e.g., `yay -S eclipse-java-bin`). Check AUR comments for dependency issues.
- **Service Issues**: Verify service status with `systemctl status <service>`.

## General Notes
- **AUR Risks**: AUR packages (e.g., Brave, MongoDB, Timeshift) are user-maintained. Review PKGBUILDs for security.
- **Time**: Installation may take 1-2 hours, especially for AUR builds and locale generation.
- **Sources**: Scripts are based on Arch Wiki, `pacman` documentation, and AUR guidelines.

For additional tools or modifications, edit the respective script or contact the maintainer.