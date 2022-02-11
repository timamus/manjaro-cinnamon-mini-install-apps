# manjaro-cinnamon-mini-install-apps
Manjaro cinnamon minimal installation apps scripts

## Link for readme file

`https://raw.githubusercontent.com/timamus/manjaro-cinnamon-mini-install-apps/main/README.md`

## Quick start

- `git clone https://github.com/timamus/manjaro-cinnamon-mini-install-apps.git`
- `cd manjaro-cinnamon-mini-install-apps/`
- `find ./ -name "*.sh" -exec chmod +x {} \;`
- `./1_system_upgrade.sh`
- `./2_install_system_apps.sh`
- `./3_install_main_apps.sh`
- `./4_install_develop_apps.sh`
- `./5_settings.sh`

## How to do manual partitioning

First, click on the "New Partition Table" button and select "GUID Partition Table (GPT)". 

My recommendation:

1. BOOT PARTITION\*  
   Select the free space → Create  
   a. Size → input 512  
   b. Filesystem → select FAT32  
   c. Mountpoint → select /boot or /boot/efi  
   d. Flags → check boot → OK  

2. ROOT PARTITION  
   Select the free space → Create  
   a. Size → use all remaining available space  
   b. Filesystem → select ext4  
   c. Encrypted → check the box and enter the password  
   d. Mountpoint → select / (root) → OK  

Install boot loader on: Master Boot Record of SOME_DISK_NAME (/dev/sda)

\* Manjaro encrypts your kernel and initramfs, by default. This means, that grub has to unlock the volume before loading your kernel. Unfortunately, grub does not provide a lot of options at that point. When distros, like pop, are showing you are a “pretty” unlock screen, they are using plymouth or something similar to do that. However, that requires that your kernel and initramfs be kept in an unencrypted location. If you are OK with that, during the install create an unencrypted /boot partition. Then you can install plymouth after the fact.

## Creating and Enabling a Static Swapfile

There is no reason you can't have both a swap partition and a swapfile. This is an easy way to add more swap without repartitioning.

For more modern systems (>4GB), your swap space should be at a minimum be ROUNDUP(SQRT(RAM)) I.E. the square root of your RAM size rounded up to the next GB. However, if you use hibernation, you need a minimum of physical memory (RAM) size plus ROUNDUP(SQRT(RAM)). The maximum, is again twice the amount of RAM, again because of diminishing returns.

Below is a script that creates a swap file with automatic determination of its size for hibernation.

```bash
TOTAL_MEMORY_G=$(awk '/MemTotal/ { print ($2 / 1048576) }' /proc/meminfo) && 
TOTAL_MEMORY_ROUND=$(echo "$TOTAL_MEMORY_G" | awk '{print ($0-int($0)<0.499)?int($0):int($0)+1}') && 
TOTAL_MEMORY_SQRT=$(echo "$TOTAL_MEMORY_G" | awk '{print sqrt($1)}') && 
ADD_SWAP_SIZE=$(echo "$TOTAL_MEMORY_SQRT" | awk '{print ($0-int($0)<0.499)?int($0):int($0)+1}') && 
SWAP_SIZE_WITH_HYBER=$(($TOTAL_MEMORY_ROUND + $ADD_SWAP_SIZE)) && 
sudo dd if=/dev/zero of=/swapfile bs=1G count=$SWAP_SIZE_WITH_HYBER status=progress && 
sudo chmod 600 /swapfile && 
sudo mkswap /swapfile && 
sudo swapon /swapfile && 
sudo bash -c "echo /swapfile none swap defaults 0 0 >> /etc/fstab" && 
SWAP_DEVICE=$(findmnt -no UUID -T /swapfile) && 
SWAP_FILE_OFFSET=$(sudo filefrag -v /swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}') && 
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="resume=UUID='"$SWAP_DEVICE"' resume_offset='"$SWAP_FILE_OFFSET"' /' /etc/default/grub && 
sudo sed -i '52 s/fsck/resume fsck/' /etc/mkinitcpio.conf && 
sudo mkinitcpio -P && sudo update-grub
```

If the RAM size changes, use the following script to delete the swapfile and its configuration.

```bash
sudo sed -i '/swapfile none swap defaults 0 0/d' /etc/fstab && 
SWAP_DEVICE=$(findmnt -no UUID -T /swapfile) && 
SWAP_FILE_OFFSET=$(sudo filefrag -v /swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}') && 
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="resume=UUID='"$SWAP_DEVICE"' resume_offset='"$SWAP_FILE_OFFSET"' /GRUB_CMDLINE_LINUX_DEFAULT="/' /etc/default/grub && 
sudo sed -i '52 s/resume fsck/fsck/' /etc/mkinitcpio.conf && 
sudo mkinitcpio -P && sudo update-grub && 
sudo swapoff /swapfile && sudo rm -f /swapfile
```

## Changing the keyboard layout with hotkey

```bash
gsettings set org.gnome.libgnomekbd.keyboard layouts "['us', 'ru']" && 
gsettings set org.gnome.libgnomekbd.keyboard options "['grp\tgrp:alt_shift_toggle']" && 
gsettings set org.cinnamon.desktop.interface keyboard-layout-show-flags false && 
gsettings set org.cinnamon.desktop.interface keyboard-layout-use-upper true
```

Then, install the applet 'keyboard@cinnamon.org' and run the command `sudo pacman -S iso-flag-png` to support flags if you need

## Changing default fonts in the system

```bash
gsettings set org.cinnamon.desktop.interface font-name "Ubuntu 10" && 
gsettings set org.nemo.desktop font "Ubuntu 10" && 
gsettings set org.cinnamon.desktop.wm.preferences titlebar-font "Ubuntu Semi-Bold 10"
```

Return to default:

```bash
gsettings set org.cinnamon.desktop.interface font-name "Cantarell 10" && 
gsettings set org.nemo.desktop font "Cantarell 10" && 
gsettings set org.cinnamon.desktop.wm.preferences titlebar-font "Cantarell 10"
```

## Installing and using the Timeshift auto-snapshot script

Timeshift auto-snapshot script which runs before package upgrade using Pacman hook. To install, type the command:

`sudo pacman -S timeshift-autosnap-manjaro`

Allow system snapshots to be created via rsync, for ext4 volumes, using the command below. Snapshots are saved by default on the system partition in path /run/timeshift/backup/timeshift/snapshots. Timeshift exclude the /root and /home/user folders by default.

`sudo sed -i 's/skipRsyncAutosnap=true/skipRsyncAutosnap=false/' /etc/timeshift-autosnap.conf`

List snapshots:

`sudo timeshift --list`

Restore a snapshot (selecting which snapshot to restore interactively):

`sudo timeshift --restore`

## Firefox Options

Addons:

- https://addons.mozilla.org/ru/firefox/addon/adblocker-ultimate/
- https://addons.mozilla.org/ru/firefox/addon/bitwarden-password-manager/
- https://addons.mozilla.org/ru/firefox/addon/new-tab-suspender/
- https://addons.mozilla.org/ru/firefox/addon/musicpro/

## Battery Applet with Monitoring and Shutdown (BAMS)

Install the BAMS applet, then run:

```bash
mkdir $HOME/batterymonitor@pdcurtis && 
cp $HOME/.local/share/cinnamon/applets/batterymonitor@pdcurtis/stylesheet.css $HOME/batterymonitor@pdcurtis && 
sed -i -e '9 s/rgba(0,255,0,0.3)/rgba(0,0,0,0.1)/' -e '13 s/rgba(0,255,0,0.5)/rgba(0,0,0,0.1)/' $HOME/batterymonitor@pdcurtis/stylesheet.css
```

Install dependencies:

`sudo pacman -S upower sox zenity`

Then, in the applet settings, select the option 'Compact - Battery Percentage without extended messages' in the 'Display Mode' area.

## Splash screen

Plymouth is an application that provides the ability to show a graphical boot animation during the system boot process. To install and configure Plymouth, use the script below, once:

```bash
sudo pacman -S plymouth && 
KERNEL_DRIVER=$(lspci -nnk | egrep -i --color 'vga|3d|2d' -A3 | grep 'in use' | sed -r 's/^[^:]*: //') && 
sudo sed -i 's/MODULES=""/MODULES="'"$KERNEL_DRIVER"'"/' /etc/mkinitcpio.conf && 
sudo sed -i -e '52 s/base udev/base udev plymouth/' -e '52 s/encrypt/plymouth-encrypt/' /etc/mkinitcpio.conf && 
sudo mkinitcpio -P && 
sudo sed -i 's/quiet/quiet splash/' /etc/default/grub && 
sudo update-grub && 
sudo systemctl disable lightdm && 
sudo systemctl enable lightdm-plymouth
```

Note: This does not work in every case! For a SiS 65x/M650/740 PCI/AGP VGA Display Adapter, there is no "Kernel driver in use" line.

Place a new plymouth themes into /usr/share/plymouth/themes directory. You can clone the theme repository for Plymouth, using the script below and copy the themes one by one.

```bash
git clone https://github.com/adi1090x/plymouth-themes.git $HOME/ && 
sudo cp -r $HOME/plymouth-themes/pack_3/lone /usr/share/plymouth/themes/ && 
sudo plymouth-set-default-theme -R lone
```

Or install themes from the official repository

- `sudo pacman -S plymouth-theme-manjaro`
- `sudo pacman -S plymouth-theme-manjaro-cinnamon`
- `sudo pacman -S plymouth-theme-manjaro-circle`
- `sudo pacman -S plymouth-theme-manjaro-deepin`
- `sudo pacman -S plymouth-theme-manjaro-deepin-circle`
- `sudo pacman -S plymouth-theme-manjaro-elegant`
- `sudo pacman -S plymouth-theme-manjaro-elegant-hidpi`
- `sudo pacman -S plymouth-theme-manjaro-extra-elegant`
- `sudo pacman -S plymouth-theme-manjaro-fancy-budgie`
- `sudo pacman -S plymouth-theme-manjaro-gnome`
- `sudo pacman -S plymouth-theme-manjaro-gnome-17.0`
- `sudo pacman -S plymouth-theme-manjaro-redefined-bsplash`
- `sudo pacman -S plymouth-theme-manjaro-very-elegant`

To find out which driver you are using you can use the following command: `lspci -k | grep -EA3 'VGA|3D|Display'`

Run the script below to determine the screen resolution and update the grub file, if necessary:

```bash
RESOLUTION=$(xdpyinfo | awk '/dimensions/ {print $2}') && 
sudo sed -i 's/GRUB_GFXMODE=auto/GRUB_GFXMODE='"$RESOLUTION"'/' /etc/default/grub && 
sudo update-grub
```

Identify the display manager used in the system: `systemctl status display-manager`

## Settings

```bash
/org/cinnamon/desktop/screensaver/lock-delay
  uint32 15
  
/org/cinnamon/desktop/sound/maximum-volume
  150
 
 
/org/cinnamon/desktop/interface/text-scaling-factor
  1.2000000000000002

/org/cinnamon/desktop/background/picture-options
  'stretched'
 
```

install proprietary driver - Parameters -> Manjaro Settings Manager

- ScreenShot+RecordDesktop(Записывает в видео область рабочего стола. После добавления апплета необходимо выполнить команду "sudo apt install ffmpeg xdotool x11-utils").

10) Пуск -> Параметры -> Десклеты. Можно поставить десклеты: Disk Space, Binary Clock^2. Для Disk Space включить следующие опции в настройках: Hide decorations, Use a custom circle color. Для Binary Clock^2 можно настроить Pip size: 12. В общих настройках убрать Привязка десклета к сетке;

https://wallpaperaccess.com/manjaro

https://www.reddit.com/r/wallpaper/

https://www.reddit.com/r/wallpaper/comments/sox44n/chill_vibes_3440_1440/

https://www.reddit.com/r/wallpaper/comments/sp0j3j/mountain_view_5120x2880/

https://www.reddit.com/r/wallpaper/comments/sovzwy/so_peaceful_3840x2160/

## Man

`sudo pacman -Sy`

I would also recommend aliasing yay to 'yay --aur' if you want to keep yay and pacman separate

If I want to update only arch packages I use pacman, if I want to update and/or access AUR I use yay.
For a full system update (arch and AUR) I use yay -Syu --noconfirm --cleanafter
