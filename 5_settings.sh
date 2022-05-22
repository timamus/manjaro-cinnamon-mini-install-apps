#!/usr/bin/env bash

set -Eeuo pipefail

# Creating a swap file with automatic determination of its size for hibernation
echo -en "\033[1;33m Creating a swap file with automatic determination of its size for hibernation... \033[0m \n"
# Calculate required swap size
TOTAL_MEMORY_G=$(awk '/MemTotal/ { print ($2 / 1048576) }' /proc/meminfo)
TOTAL_MEMORY_ROUND=$(echo "$TOTAL_MEMORY_G" | awk '{print ($0-int($0)<0.499)?int($0):int($0)+1}')
TOTAL_MEMORY_SQRT=$(echo "$TOTAL_MEMORY_G" | awk '{print sqrt($1)}')
ADD_SWAP_SIZE=$(echo "$TOTAL_MEMORY_SQRT" | awk '{print ($0-int($0)<0.499)?int($0):int($0)+1}')
# A block size of 1 mebibyte is better, in case of a small amount of RAM, the dd process will not be killed by oomkiller
SWAP_SIZE_WITH_HYBER_M=$((($TOTAL_MEMORY_ROUND + $ADD_SWAP_SIZE) * 1024))
ROOT_PATH=$(cat /proc/cmdline | sed -e 's/^.*root=//' -e 's/ .*$//')
if [[ -z "$(swapon -s)" ]]; then # Check if there is any swap (partition or file), if not, then create it
  if [[ $(lsblk -no FSTYPE $ROOT_PATH) == "ext4" ]]; then # Configure swap for ext4 with hibernate support
    sudo dd if=/dev/zero of=/swapfile bs=1M count=$SWAP_SIZE_WITH_HYBER_M status=progress
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    sudo bash -c "echo -e '# Swapfile for hibernation support\n/swapfile none swap defaults 0 0' >> /etc/fstab"
    SWAP_DEVICE=$(findmnt -no UUID -T /swapfile)
    SWAP_FILE_OFFSET=$(sudo filefrag -v /swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}')
    sudo mkdir -p /etc/default/grub.d/
    if [[ -z $(grep "source /etc/default/grub.d/*" /etc/default/grub) ]]
      then
        sudo bash -c "echo -e '\n\nsource /etc/default/grub.d/*' >> /etc/default/grub"
    fi
    sudo bash -c "echo -e '# Added by a script\nGRUB_CMDLINE_LINUX_DEFAULT=\"\$GRUB_CMDLINE_LINUX_DEFAULT resume=UUID=$SWAP_DEVICE resume_offset=$SWAP_FILE_OFFSET\"' > /etc/default/grub.d/resume.cfg"
    sudo sed -i 's/filesystems/filesystems resume/g' /etc/mkinitcpio.conf
    sudo mkinitcpio -P
    sudo update-grub
    sudo sed -i -e 's@#HibernateDelaySec=180min@HibernateDelaySec=60min@g' /etc/systemd/sleep.conf 
  fi
  # Configure swapfile on btrfs nested subvolume to maintain Timeshift compatibility with hibernate support
  if [[ $(lsblk -no FSTYPE $ROOT_PATH) == "btrfs" ]]; then
    sudo mount $ROOT_PATH /mnt
    sudo btrfs subvolume create /mnt/@swap
    sudo umount /mnt
    sudo mkdir /swap
    sudo mount -o subvol=@swap $ROOT_PATH /swap
    sudo touch /swap/swapfile
    sudo truncate -s 0 /swap/swapfile
    sudo chattr +C /swap/swapfile
    sudo btrfs property set /swap/swapfile compression none
    sudo dd if=/dev/zero of=/swap/swapfile bs=1M count=$SWAP_SIZE_WITH_HYBER_M status=progress
    sudo chmod 0600 /swap/swapfile
    sudo mkswap /swap/swapfile
    sudo bash -c "echo -e '# Swapfile for hibernation support, on nested subvolume\n"$ROOT_PATH"\t/swap\tbtrfs\tsubvol=@swap\t0\t0\n/swap/swapfile\tnone\tswap\tsw\t0\t0' >> /etc/fstab"
    [[ -z $(swapon -s | grep "/swap/swapfile") ]] && sudo swapon /swap/swapfile
    # Enable Hibernation
    # pm-utils should be there for legacy support, but since Manjaro uses systemd, it would be obsolete (will be removed after clearly verified)  
    # pacman -S --noconfirm pm-utils
    PHYS_OFFSET=$(sudo ./btrfs_map_physical /swap/swapfile | sed -n '2 p' | awk '{print $(NF)}')
    PAGESIZE=$(getconf PAGESIZE)
    RESUME_OFFSET=$((PHYS_OFFSET / PAGESIZE))
    UUID=$(findmnt -no UUID -T /swap/swapfile)
    sudo mkdir -p /etc/default/grub.d/
    if [[ -z $(grep "source /etc/default/grub.d/*" /etc/default/grub) ]]
      then
        sudo bash -c "echo -e '\n\nsource /etc/default/grub.d/*' >> /etc/default/grub"
    fi
    sudo bash -c "echo -e '# Added by a script\nGRUB_CMDLINE_LINUX_DEFAULT=\"\$GRUB_CMDLINE_LINUX_DEFAULT resume=UUID=$UUID resume_offset=$RESUME_OFFSET\"' > /etc/default/grub.d/resume.cfg"
    if [[ -z $(grep "resume" /etc/mkinitcpio.conf) ]]
      then
        sudo sed -i "s/filesystems/filesystems resume/g" /etc/mkinitcpio.conf 
    fi
    # Due no support for btrfs we need to bypass the memory check
    sudo mkdir -p /etc/systemd/system/systemd-logind.service.d/		
    sudo mkdir -p /etc/systemd/system/systemd-hibernate.service.d/		
    logind="/etc/systemd/system/systemd-logind.service.d/bypass_hibernation_memory_check.conf"
    hibernate="/etc/systemd/system/systemd-hibernate.service.d/bypass_hibernation_memory_check.conf"
    if [[ ! -f $logind ]]
      then
        sudo bash -c "echo -e '#Added by a script\nEnvironment=SYSTEMD_BYPASS_HIBERNATION_MEMORY_CHECK=1' > /etc/systemd/system/systemd-logind.service.d/bypass_hibernation_memory_check.conf"
    fi
    if [[ ! -f $hibernate ]]
      then
        sudo bash -c "echo -e '#Added by a script\nEnvironment=SYSTEMD_BYPASS_HIBERNATION_MEMORY_CHECK=1' > /etc/systemd/system/systemd-hibernate.service.d/bypass_hibernation_memory_check.conf"
    fi
    sudo mkinitcpio -P
    sudo update-grub
    sudo sed -i -e 's@#HibernateDelaySec=180min@HibernateDelaySec=60min@g' /etc/systemd/sleep.conf
  fi
else
  echo -en "\033[0;31m Swap already exists! \033[0m \n"
fi

# Installing cantarell fonts 0.301-1 from a local folder. To install plymouth correctly, you may need the old "cantarell-fonts" package
echo -en "\033[1;33m Installing cantarell fonts 0.301-1 from a local folder... \033[0m \n"
sudo pacman -U --noconfirm Fonts/"cantarell-fonts-1 0.301-1-any.pkg.tar.zst"
sudo sed -i '/IgnorePkg = cantarell-fonts/d' /etc/pacman.conf
sudo sed -i '/^#IgnoreGroup.*/i IgnorePkg = cantarell-fonts' /etc/pacman.conf

# Installing and configuring plymouth
echo -en "\033[1;33m Installing and configuring plymouth... \033[0m \n"
sudo pacman -S --noconfirm plymouth
KERNEL_DRIVER=$(lspci -nnk | egrep -i --color 'vga|3d|2d' -A3 | grep 'in use' | head -1 | sed -r 's/^[^:]*: //')
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
    sudo sed -i 's/quiet/video=efifb:nobgrt nvidia-drm.modeset=1 quiet splash/' /etc/default/grub
  fi
  if [[ "$KERNEL_DRIVER" = "i915" ]] ; then
    sudo sed -i 's/quiet/video=efifb:nobgrt i915.modeset=1 quiet splash/' /etc/default/grub
  fi
  if [[ "$KERNEL_DRIVER" = "radeon" ]] ; then
    sudo sed -i 's/quiet/video=efifb:nobgrt radeon.modeset=1 quiet splash/' /etc/default/grub
  fi
fi
sudo update-grub
sudo systemctl disable lightdm
sudo systemctl enable lightdm-plymouth
sudo pacman -S --noconfirm plymouth-theme-manjaro-elegant

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
if [[ $(lsblk -no FSTYPE $ROOT_PATH) == "ext4" ]]; then
  # Allow system snapshots to be created via rsync for ext4 volumes
  sudo sed -i 's/skipRsyncAutosnap=true/skipRsyncAutosnap=false/' /etc/timeshift-autosnap.conf
fi
if [[ $(lsblk -no FSTYPE $ROOT_PATH) == "btrfs" ]]; then
  # Increasing the number of snapshots for btrfs
  sudo sed -i -e 's@#maxSnapshots=3@maxSnapshots=15@g' /etc/timeshift-autosnap.conf
  # Installing grub-btrfs
  sudo pacman -S --noconfirm grub-btrfs
  # Enable automatically update grub upon snapshot with Timeshift
  sudo systemctl enable grub-btrfs.path
  sudo systemctl start grub-btrfs.path
fi

echo -en "\033[0;35m System settings are completed \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
