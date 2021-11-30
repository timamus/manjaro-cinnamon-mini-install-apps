#!/bin/bash

# Update mirror list and set fastest download server
sudo pacman-mirrors --fasttrack --api --protocol https

# Start by updating and upgrading all packages installed in the system
sudo pacman -Syyu

# Installing Flatpak
pamac install flatpak libpamac-flatpak-plugin

# Enable Flatpak for pamac (uncomment the line #EnableFlatpak)
echo "Enable Flatpak for pamac"
if grep -q "EnableFlatpak" /etc/pamac.conf; then
   sudo sed -Ei '/EnableFlatpak/s/^#//' /etc/pamac.conf
   # To comment it back
   # sudo sed -Ei '/EnableFlatpak/s/^/#/' /etc/pamac.conf
else
   sudo sed -i -e '$a\\' -e "\$ a EnableFlatpak" /etc/pamac.conf
fi

# Enable Flatpak updates for pamac (uncomment the line #CheckFlatpakUpdates)
echo "Enable Flatpak updates for pamac"
if grep -q "CheckFlatpakUpdates" /etc/pamac.conf; then
   sudo sed -Ei '/CheckFlatpakUpdates/s/^/#/' /etc/pamac.conf
else
   sudo sed -i -e '$a\\' -e "\$ a CheckFlatpakUpdates" /etc/pamac.conf
fi

# Enable AUR for pamac (uncomment the line #EnableAUR)
echo "Enable AUR for pamac"
sudo sed -Ei '/EnableAUR/s/^#//' /etc/pamac.conf
# To comment it back
# sudo sed -Ei '/EnableAUR/s/^/#/' /etc/pamac.conf

# Enable AUR updates for pamac (uncomment the line #CheckAURUpdates)
echo "Enable AUR updates for pamac"
sudo sed -Ei '/CheckAURUpdates/s/^/#/' /etc/pamac.conf

echo "Installation successfull"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
