#!/usr/bin/env bash

set -Eeuo pipefail

# Creating a swap file with automatic determination of its size for hibernation
echo -en "\033[1;33m Creating a swap file with automatic determination of its size for hibernation... \033[0m \n"
if [[ -z "$(swapon -s)" ]]; then # Check if there is any swap (partition or file), if not, then create it
  TOTAL_MEMORY_G=$(awk '/MemTotal/ { print ($2 / 1048576) }' /proc/meminfo)
  TOTAL_MEMORY_ROUND=$(echo "$TOTAL_MEMORY_G" | awk '{print ($0-int($0)<0.499)?int($0):int($0)+1}')
  TOTAL_MEMORY_SQRT=$(echo "$TOTAL_MEMORY_G" | awk '{print sqrt($1)}')
  ADD_SWAP_SIZE=$(echo "$TOTAL_MEMORY_SQRT" | awk '{print ($0-int($0)<0.499)?int($0):int($0)+1}')
  # A block size of 1 mebibyte is better, in case of a small amount of RAM, the dd process will not be killed by oomkiller
  SWAP_SIZE_WITH_HYBER_M=$((($TOTAL_MEMORY_ROUND + $ADD_SWAP_SIZE) * 1024))
  sudo dd if=/dev/zero of=/swapfile bs=1M count=$SWAP_SIZE_WITH_HYBER_M status=progress
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
else
  echo -en "\033[0;31m Swap already exists! \033[0m \n"
fi

# Installing cantarell fonts 0.301-1 from a local folder. To install plymouth correctly, you may need the old "cantarell-fonts" package
echo -en "\033[1;33m Installing cantarell fonts 0.301-1 from a local folder... \033[0m \n"
sudo pacman -U --noconfirm Fonts/"cantarell-fonts-1 0.301-1-any.pkg.tar.zst"
sudo sed -i '/^#IgnoreGroup.*/i IgnorePkg = cantarell-fonts' /etc/pacman.conf

# Installing and configuring plymouth
echo -en "\033[1;33m Installing and configuring plymouth... \033[0m \n"
sudo pacman -S --noconfirm plymouth
KERNEL_DRIVER=$(lspci -nnk | egrep -i --color 'vga|3d|2d' -A3 | grep 'in use' | sed -r 's/^[^:]*: //')
if [[ "$KERNEL_DRIVER" = "nvidia" ]] ; then
  sudo sed -i 's/MODULES=""/MODULES="nvidia nvidia_modeset nvidia_uvm nvidia_drm"/' /etc/mkinitcpio.conf
else
  sudo sed -i 's/MODULES=""/MODULES="'"$KERNEL_DRIVER"'"/' /etc/mkinitcpio.conf
fi
NUM_LINE_HOOKS=$(sed -n '/HOOKS="/=' /etc/mkinitcpio.conf)
if ! grep -q "plymouth" /etc/mkinitcpio.conf ; then
  sudo sed -i -e ''"$NUM_LINE_HOOKS"' s/base udev/base udev plymouth/' -e ''"$NUM_LINE_HOOKS"' s/encrypt/plymouth-encrypt/' /etc/mkinitcpio.conf
fi
sudo mkinitcpio -P
if ! grep -q "splash" /etc/default/grub ; then
  if [[ "$KERNEL_DRIVER" = "nvidia" ]] ; then
    sudo sed -i 's/quiet/nvidia-drm.modeset=1 quiet splash/' /etc/default/grub
  fi
fi
sudo update-grub
sudo systemctl disable lightdm
sudo systemctl enable lightdm-plymouth
git clone https://github.com/adi1090x/plymouth-themes.git
sudo cp -r plymouth-themes/pack_3/lone /usr/share/plymouth/themes/
sudo plymouth-set-default-theme -R lone

# Changing the keyboard layout with hotkey
echo -en "\033[1;33m Changing the keyboard layout with hotkey... \033[0m \n"
sudo pacman -S --noconfirm iso-flag-png
if [ $(locale | sed -n 's/^LANG=//p') == "ru_RU.UTF-8" ]; then
  gsettings set org.gnome.libgnomekbd.keyboard layouts "['us', 'ru']"
fi
gsettings set org.gnome.libgnomekbd.keyboard options "['grp\tgrp:alt_shift_toggle']"
gsettings set org.cinnamon.desktop.interface keyboard-layout-show-flags false
gsettings set org.cinnamon.desktop.interface keyboard-layout-use-upper true

# Changing default fonts in the system
echo -en "\033[1;33m Changing default fonts in the system... \033[0m \n"
gsettings set org.cinnamon.desktop.interface font-name "Ubuntu 10"
gsettings set org.nemo.desktop font "Ubuntu 10"
gsettings set org.cinnamon.desktop.wm.preferences titlebar-font "Ubuntu Semi-Bold 10"

# Changing some Cinnamon settings (screen saver, sound, background)
echo -en "\033[1;33m Changing some Cinnamon settings (screen saver, sound, background)... \033[0m \n"
# Delay before screen saver is blocked
gsettings set org.cinnamon.desktop.screensaver lock-delay 15
# Setting the sound volume to 150%
gsettings set org.cinnamon.desktop.sound maximum-volume 150
# Background image format
gsettings set org.cinnamon.desktop.background picture-options 'stretched'
# Window frames 
gsettings set org.cinnamon.desktop.wm.preferences theme 'Mint-Y'
# In the right menu bar, reduce the size of the color icon to 16 px from 24px
gsettings set org.cinnamon panel-zone-icon-sizes '[{"panelId": 1, "left": 48, "center": 0, "right": 16}]'

# Setting up timeshift
echo -en "\033[1;33m Configure timeshift for your PC. After setting up, close timeshift and the installation script will continue. This is necessary for the timeshift-autosnap script to work correctly... \033[0m \n"
sudo timeshift-launcher

# Installing and enable the Timeshift auto-snapshot script for ext4 volumes
echo -en "\033[1;33m Installing and enable the Timeshift auto-snapshot script for ext4 volumes... \033[0m \n"
sudo pacman -S --noconfirm timeshift-autosnap-manjaro
# Allow system snapshots to be created via rsync for ext4 volumes
sudo sed -i 's/skipRsyncAutosnap=true/skipRsyncAutosnap=false/' /etc/timeshift-autosnap.conf

echo -en "\033[0;35m System settings are completed \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
