#!/usr/bin/env bash

set -Eeuo pipefail

# Adding btrfs mount options
ROOT_PATH=$(cat /proc/cmdline | sed -e 's/^.*root=//' -e 's/ .*$//')
if [[ $(lsblk -no FSTYPE $ROOT_PATH) == "btrfs" ]]; then
   sudo sed -i '/\/@/s/defaults/defaults,noatime,discard=async,compress=zstd/' /etc/fstab
   sudo sed -i '/\/@home/s/defaults/defaults,noatime,discard=async,compress=zstd/' /etc/fstab
   sudo mount -a
fi

# Update mirror list and set fastest download server
echo -en "\033[1;33m Update mirror list and set fastest download server... \033[0m \n"
sudo pacman-mirrors --fasttrack --api --protocol https

# Start by updating and upgrading all packages installed in the system
echo -en "\033[1;33m Start by updating and upgrading all packages installed in the system... \033[0m \n"
sudo pacman -Syu

# Installing Flatpak
echo -en "\033[1;33m Installing Flatpak... \033[0m \n"
sudo pacman -S --noconfirm flatpak libpamac-flatpak-plugin # pamac install flatpak libpamac-flatpak-plugin

# Enable Flatpak for pamac (uncomment the line #EnableFlatpak)
echo -en "\033[1;33m Enable Flatpak for pamac... \033[0m \n"
if grep -q "EnableFlatpak" /etc/pamac.conf; then
   sudo sed -Ei '/EnableFlatpak/s/^#//' /etc/pamac.conf
   # To comment it back
   # sudo sed -Ei '/EnableFlatpak/s/^/#/' /etc/pamac.conf
else
   sudo sed -i -e '$a\\' -e "\$ a EnableFlatpak" /etc/pamac.conf
fi

# Enable Flatpak updates for pamac (uncomment the line #CheckFlatpakUpdates)
echo -en "\033[1;33m Enable Flatpak updates for pamac... \033[0m \n"
if grep -q "CheckFlatpakUpdates" /etc/pamac.conf; then
   sudo sed -Ei '/CheckFlatpakUpdates/s/^#//' /etc/pamac.conf
else
   sudo sed -i -e '$a\\' -e "\$ a CheckFlatpakUpdates" /etc/pamac.conf
fi

# Enable AUR for pamac (uncomment the line #EnableAUR)
echo -en "\033[1;33m Enable AUR for pamac... \033[0m \n"
sudo sed -Ei '/EnableAUR/s/^#//' /etc/pamac.conf
# To comment it back
# sudo sed -Ei '/EnableAUR/s/^/#/' /etc/pamac.conf

# Enable AUR updates for pamac (uncomment the line #CheckAURUpdates)
echo -en "\033[1;33m Enable AUR updates for pamac... \033[0m \n"
sudo sed -Ei '/CheckAURUpdates/s/^#//' /etc/pamac.conf

# Automatic detection and installation of the best available proprietary driver for a pci-connected graphics card, if used
echo -en "\033[1;33m Automatic detection and installation of the best available proprietary driver for a pci-connected graphics card, if used... \033[0m \n"
sudo mhwd -a pci nonfree 0300

echo -en "\033[0;35m Installation successfull \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
