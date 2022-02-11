#!/usr/bin/env bash

set -Eeuo pipefail

# Creating a swap file with automatic determination of its size for hibernation
echo -en "\033[1;33m Creating a swap file with automatic determination of its size for hibernation... \033[0m \n"
TOTAL_MEMORY_G=$(awk '/MemTotal/ { print ($2 / 1048576) }' /proc/meminfo)
TOTAL_MEMORY_ROUND=$(echo "$TOTAL_MEMORY_G" | awk '{print ($0-int($0)<0.499)?int($0):int($0)+1}')
TOTAL_MEMORY_SQRT=$(echo "$TOTAL_MEMORY_G" | awk '{print sqrt($1)}')
ADD_SWAP_SIZE=$(echo "$TOTAL_MEMORY_SQRT" | awk '{print ($0-int($0)<0.499)?int($0):int($0)+1}')
SWAP_SIZE_WITH_HYBER=$(($TOTAL_MEMORY_ROUND + $ADD_SWAP_SIZE))
sudo dd if=/dev/zero of=/swapfile bs=1G count=$SWAP_SIZE_WITH_HYBER status=progress
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo bash -c "echo /swapfile none swap defaults 0 0 >> /etc/fstab"
SWAP_DEVICE=$(findmnt -no UUID -T /swapfile)
SWAP_FILE_OFFSET=$(sudo filefrag -v /swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}')
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="resume=UUID='"$SWAP_DEVICE"' resume_offset='"$SWAP_FILE_OFFSET"' /' /etc/default/grub
sudo sed -i '52 s/fsck/resume fsck/' /etc/mkinitcpio.conf
sudo mkinitcpio -P
sudo update-grub

# Installing and configuring plymouth
echo -en "\033[1;33m Installing and configuring plymouth... \033[0m \n"
sudo pacman -S plymouth
KERNEL_DRIVER=$(lspci -nnk | egrep -i --color 'vga|3d|2d' -A3 | grep 'in use' | sed -r 's/^[^:]*: //')
sudo sed -i 's/MODULES=""/MODULES="'"$KERNEL_DRIVER"'"/' /etc/mkinitcpio.conf
sudo sed -i -e '52 s/base udev/base udev plymouth/' -e '52 s/encrypt/plymouth-encrypt/' /etc/mkinitcpio.conf
sudo mkinitcpio -P
sudo sed -i 's/quiet/quiet splash/' /etc/default/grub
sudo update-grub
sudo systemctl disable lightdm
sudo systemctl enable lightdm-plymouth
git clone https://github.com/adi1090x/plymouth-themes.git $HOME/
sudo cp -r $HOME/plymouth-themes/pack_3/lone /usr/share/plymouth/themes/
sudo plymouth-set-default-theme -R lone

# Changing the keyboard layout with hotkey
echo -en "\033[1;33m Changing the keyboard layout with hotkey... \033[0m \n"
sudo pacman -S iso-flag-png
gsettings set org.gnome.libgnomekbd.keyboard layouts "['us', 'ru']"
gsettings set org.gnome.libgnomekbd.keyboard options "['grp\tgrp:alt_shift_toggle']"
gsettings set org.cinnamon.desktop.interface keyboard-layout-show-flags false
gsettings set org.cinnamon.desktop.interface keyboard-layout-use-upper true

# Changing default fonts in the system
echo -en "\033[1;33m Changing default fonts in the system... \033[0m \n"
gsettings set org.cinnamon.desktop.interface font-name "Ubuntu 10"
gsettings set org.nemo.desktop font "Ubuntu 10"
gsettings set org.cinnamon.desktop.wm.preferences titlebar-font "Ubuntu Semi-Bold 10"

# 
gsettings set org.cinnamon.desktop.screensaver lock-delay 15
gsettings set org.cinnamon.desktop.sound maximum-volume 150
gsettings set org.cinnamon.desktop.interface text-scaling-factor 1.2

echo -en "\033[0;35m System settings are completed \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
