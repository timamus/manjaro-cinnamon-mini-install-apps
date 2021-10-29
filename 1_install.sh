#!/bin/bash

# Update mirror list and set fastest download server
sudo pacman-mirrors -c Russia
# or
# sudo pacman-mirrors --fasttrack

# Start by updating and upgrading all packages installed in the system
sudo pacman -Syyu

# Installing Flatpak
pamac install flatpak libpamac-flatpak-plugin

# Enable Flatpak for pamac (uncomment the line #EnableFlatpak)
echo "Enable Flatpak for pamac"
sudo sed -Ei '/EnableFlatpak/s/^#//' /etc/pamac.conf
# To comment it back
# sudo sed -Ei '/EnableFlatpak/s/^/#/' /etc/pamac.conf

# Enable AUR for pamac (uncomment the line #EnableAUR)
echo "Enable AUR for pamac"
sudo sed -Ei '/EnableAUR/s/^#//' /etc/pamac.conf
# To comment it back
# sudo sed -Ei '/EnableAUR/s/^/#/' /etc/pamac.conf

echo "Installation successfull"
reboot () { echo 'Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot; }
