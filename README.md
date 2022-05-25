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

1. EFI PARTITION\*  
   Select the free space → Create  
   a. Size → input 300  
   b. Filesystem → select FAT32  
   c. Mountpoint → select /boot/efi  
   d. Flags → check boot → OK  

2. BOOT PARTITION\*  
   Select the free space → Create  
   a. Size → input 768  
   b. Filesystem → select ext4  
   c. Mountpoint → select /boot  

3. ROOT PARTITION  
   Select the free space → Create  
   a. Size → use all remaining available space  
   b. Filesystem → select ext4  
   c. Encrypted → check the box and enter the password  
   d. Mountpoint → select / (root) → OK  

Install boot loader on: Master Boot Record of SOME_DISK_NAME (/dev/sda)

\* Manjaro encrypts your kernel and initramfs, by default. This means, that grub has to unlock the volume before loading your kernel. Unfortunately, grub does not provide a lot of options at that point. When distros, like pop, are showing you are a "pretty" unlock screen, they are using plymouth or something similar to do that. However, that requires that your kernel and initramfs be kept in an unencrypted location. If you are OK with that, during the install create an unencrypted /boot partition. Then you can install plymouth after the fact.

## Creating and Enabling a Static Swapfile

There is no reason you can't have both a swap partition and a swapfile. This is an easy way to add more swap without repartitioning.

For more modern systems (>4GB), your swap space should be at a minimum be ROUNDUP(SQRT(RAM)) I.E. the square root of your RAM size rounded up to the next GB. However, if you use hibernation, you need a minimum of physical memory (RAM) size plus ROUNDUP(SQRT(RAM)). The maximum, is again twice the amount of RAM, again because of diminishing returns.

How to create and enable a swapfile for the ext4 or btrfs file system, see the script file "5_settings.sh"

If the RAM size changes, use the following script to delete the swapfile and its configuration for EXT4.

```bash
sudo swapoff /swapfile && 
sudo sed -i '/[Ss]wap/d' /etc/fstab && 
sudo mount -a && 
sudo systemctl daemon-reload && 
[[ -d /etc/default/grub.d ]] && sudo rm -rf /etc/default/grub.d 
sudo sed -i 's/filesystems resume/filesystems/g' /etc/mkinitcpio.conf && 
[[ -f /swapfile ]] && sudo rm -rf /swapfile 
sudo mkinitcpio -P && 
sudo update-grub
```

Also, use the following script to delete the swapfile and its configuration for BTRFS.

```bash
sudo swapoff /swap/swapfile && 
sudo sed -i '/[Ss]wap/d' /etc/fstab && 
sudo mount -a && 
sudo systemctl daemon-reload && 
sudo umount /swap && 
ROOT_PATH=$(cat /proc/cmdline | sed -e 's/^.*root=//' -e 's/ .*$//') && 
sudo mount $ROOT_PATH /mnt && 
sudo btrfs subvolume delete /mnt/@swap && 
sudo umount /mnt && 
[[ -d /swap ]] && sudo rm -rf /swap 
sudo sed -i '/grub.d/d' /etc/default/grub && 
[[ -d /etc/default/grub.d ]] && sudo rm -rf /etc/default/grub.d 
[[ -d /etc/systemd/system/systemd-logind.service.d ]] && sudo rm -rf /etc/systemd/system/systemd-logind.service.d 
[[ -d /etc/systemd/system/systemd-hibernate.service.d ]] && sudo rm -rf /etc/systemd/system/systemd-hibernate.service.d 
sudo sed -i 's/filesystems resume/filesystems/g' /etc/mkinitcpio.conf && 
sudo sed -i -e 's@HibernateDelaySec=60min@#HibernateDelaySec=180min@g' /etc/systemd/sleep.conf && 
sudo mkinitcpio -P && 
sudo update-grub
```

To detect the swap location path in the script, use: `SWAP_PATH=$(swapon -s | sed -n '2 p' | awk '{print $1;}')`

## Installing and using the Timeshift auto-snapshot script

Timeshift auto-snapshot script which runs before package upgrade using Pacman hook. To install, type the command:

`sudo pacman -S timeshift-autosnap-manjaro`

Allow system snapshots to be created via rsync, for ext4 volumes, using the command below. Snapshots are saved by default on the system partition in path /run/timeshift/backup/timeshift/snapshots. Timeshift exclude the /root and /home/user folders by default.

`sudo sed -i 's/skipRsyncAutosnap=true/skipRsyncAutosnap=false/' /etc/timeshift-autosnap.conf`

List snapshots:

`sudo timeshift --list`

Restore a snapshot (selecting which snapshot to restore interactively):

`sudo timeshift --restore`

## Splash screen

Plymouth is an application that provides the ability to show a graphical boot animation during the system boot process. To install and configure Plymouth, use the script below**:

```bash
sudo pacman -S --noconfirm plymouth && 
KERNEL_DRIVER=$(lspci -nnk | egrep -i --color 'vga|3d|2d' -A3 | grep 'in use' | head -1 | sed -r 's/^[^:]*: //') && 
if [[ "$KERNEL_DRIVER" = "nvidia" ]] ; then 
  sudo sed -i 's/MODULES=""/MODULES="nvidia nvidia_modeset nvidia_uvm nvidia_drm"/' /etc/mkinitcpio.conf 
else 
  sudo sed -i 's/MODULES=""/MODULES="'"$KERNEL_DRIVER"'"/' /etc/mkinitcpio.conf 
fi 
NUM_LINE_HOOKS=$(sed -n '/HOOKS="/=' /etc/mkinitcpio.conf) && 
if ! grep -q "plymouth" /etc/mkinitcpio.conf ; then 
   sudo sed -i -e ''"$NUM_LINE_HOOKS"' s/base udev/base udev plymouth/' -e ''"$NUM_LINE_HOOKS"' s/encrypt/plymouth-encrypt/' /etc/mkinitcpio.conf 
fi 
sudo mkinitcpio -P && 
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
sudo update-grub && 
sudo systemctl disable lightdm && 
sudo systemctl enable lightdm-plymouth
```

\*\* To install plymouth correctly, you may need the old "cantarell-fonts" package. To find out how to do this, look at the script file "5_settings.sh".

Note: This does not work in every case! For a SiS 65x/M650/740 PCI/AGP VGA Display Adapter, there is no "Kernel driver in use" line.

Place a new plymouth themes into /usr/share/plymouth/themes directory. You can clone the theme repository for Plymouth, using the script below and copy the themes one by one.

```bash
git clone https://github.com/adi1090x/plymouth-themes.git && 
sudo cp -r plymouth-themes/pack_3/lone /usr/share/plymouth/themes/ && 
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

## Installing optimus-manager for hybrid graphics management

```bash
yay -S --noconfirm optimus-manager optimus-manager-qt && 
sudo systemctl enable optimus-manager.service
```

After that, run `optimus-manager-qt` and enable autoloading in the program settings. You can also change the icon from `cpu-symbolic` to `prime-intel`. Use the option `prime-run %command%` to launch each game on steam. 

## Firefox Options

Addons:

- https://addons.mozilla.org/ru/firefox/addon/ublock-origin/
- https://addons.mozilla.org/ru/firefox/addon/bitwarden-password-manager/
- https://addons.mozilla.org/ru/firefox/addon/new-tab-suspender/
- https://addons.mozilla.org/ru/firefox/addon/musicpro/

## Yandex.Disk

To configure Yandex.Disk, use the command: `yandex-disk setup`. If you plan to backup the Yandex.Disk folder via rsync, it is better not to use a dot in the folder name.

## Cinnamon Desktop Environment Settings

### Changing the keyboard layout with hotkey

```bash
gsettings set org.gnome.libgnomekbd.keyboard layouts "['us', 'ru']" && 
gsettings set org.gnome.libgnomekbd.keyboard options "['grp\tgrp:alt_shift_toggle']" && 
gsettings set org.cinnamon.desktop.interface keyboard-layout-show-flags false && 
gsettings set org.cinnamon.desktop.interface keyboard-layout-use-upper true
```

Then, install the applet "keyboard@cinnamon.org" and run the command `sudo pacman -S iso-flag-png` to support flags if you need

### Changing default fonts in the system

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

### Change the text scale, for laptops with a small display and high resolution

```bash
gsettings set org.cinnamon.desktop.interface text-scaling-factor 1.2
```

### Applets

> Battery Applet with Monitoring and Shutdown (BAMS)

Install the BAMS applet, then run:

```bash
mkdir $HOME/batterymonitor@pdcurtis && 
cp $HOME/.local/share/cinnamon/applets/batterymonitor@pdcurtis/stylesheet.css $HOME/batterymonitor@pdcurtis && 
sed -i -e '0,/rgba(0,255,0,0.3)/s//rgba(0,0,0,0)/' -e '0,/rgba(0,255,0,0.3)/s//rgba(0,0,0,0)/' -e 's/rgba(0,255,0,0.5)/rgba(0,0,0,0)/' -e '0,/red/s//rgba(0,0,0,0)/' $HOME/batterymonitor@pdcurtis/stylesheet.css
```

or to fix the BAMS applet settings directly, use the command below, but you will have to do this when the applet is updated

```bash
sed -i -e '0,/rgba(0,255,0,0.3)/s//rgba(0,0,0,0)/' -e '0,/rgba(0,255,0,0.3)/s//rgba(0,0,0,0)/' -e 's/rgba(0,255,0,0.5)/rgba(0,0,0,0)/' -e '0,/red/s//rgba(0,0,0,0)/' $HOME/.local/share/cinnamon/applets/batterymonitor@pdcurtis/3.2/stylesheet.css
```

Install dependencies: `sudo pacman -S upower sox zenity`

Then, in the applet settings, select the option "Compact - Battery Percentage without extended messages" in the "Display Mode" area.

> ScreenShot+RecordDesktop

Install dependencies: `sudo pacman -S ffmpeg xdotool xorg-xwininfo xorg-xdpyinfo`

> inhibit@cinnamon.org

### Desklets

> diskspace@schorschii

### Desktop wallpapers

- https://wallpaperaccess.com/manjaro
- https://www.reddit.com/r/wallpaper/
- https://www.reddit.com/r/wallpaper/comments/sox44n/chill_vibes_3440_1440/
- https://www.reddit.com/r/wallpaper/comments/sp0j3j/mountain_view_5120x2880/
- https://gitlab.com/tromsite/tromjaro/iso-profiles/-/tree/master/tromjaro/xfce/live-overlay/usr/share/backgrounds

### Change background for login screen

For change the login screen background, run the command below, where "some_file" is the name of the picture file:

`sudo mkdir -p /usr/share/backgrounds/login/ && sudo cp $HOME/manjaro-cinnamon-mini-install-apps/Wallpapers/< some_file > $_`, then change the background in System Settings --> Login Window.

### Favorite apps

You can change your favorite applications in System Settings --> Favorite applications:

- Music : mpv --> SMPlayer
- Video : mpv --> SMPlayer
- Photo : Pix --> Xviewer

## Other resources

- `git clone https://gitgud.io/hovereagle/manjaro_install_nonfree_components.git`
- https://jetbra.in/s

## How to update

If I want to update only arch packages I use pacman `sudo pacman -Syu`, if I want to update and/or access AUR I use yay. For a full system update (arch and AUR) I use `yay -Syu --noconfirm --cleanafter`. I would also recommend aliasing yay to `yay --aur` if you want to keep yay and pacman separate. 

If the package "timeshift-autosnap" is used, autosnaphot can be temporarily skipped by setting SKIP_AUTOSNAP environment variable (e.g. `sudo SKIP_AUTOSNAP=1 pacman -Syu`). Use `yay -Syu --combinedupgrade --batchinstall` to update multiple AUR packages at once.
