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
mkdir /$HOME/batterymonitor@pdcurtis && 
cp /$HOME/.local/share/cinnamon/applets/batterymonitor@pdcurtis/stylesheet.css /$HOME/batterymonitor@pdcurtis && 
sed -i -e '9 s/rgba(0,255,0,0.3)/rgba(0,0,0,0.1)/' -e '13 s/rgba(0,255,0,0.5)/rgba(0,0,0,0.1)/' /$HOME/batterymonitor@pdcurtis/stylesheet.css
```

Install dependencies:

`sudo pacman -S upower sox zenity`

Then, in the applet settings, select the option 'Compact - Battery Percentage without extended messages' in the 'Display Mode' area

## Splash screen

/usr/share/plymouth/themes/

To find out which driver you are using you can use the following command:

lspci -k | grep -EA3 'VGA|3D|Display'

Detect display manager: systemctl status display-manager

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

git clone https://github.com/adi1090x/plymouth-themes.git && 
sudo cp -r /$HOME/plymouth-themes/pack_3/lone /usr/share/plymouth/themes/ && 
sudo plymouth-set-default-theme -R lone
```
`sudo pacman -S plymouth-theme-manjaro`
`sudo pacman -S plymouth-theme-manjaro-cinnamon`
`sudo pacman -S plymouth-theme-manjaro-circle`
`sudo pacman -S plymouth-theme-manjaro-deepin`
`sudo pacman -S plymouth-theme-manjaro-deepin-circle`
`sudo pacman -S plymouth-theme-manjaro-elegant`
`sudo pacman -S plymouth-theme-manjaro-elegant-hidpi`
`sudo pacman -S plymouth-theme-manjaro-extra-elegant`
`sudo pacman -S plymouth-theme-manjaro-fancy-budgie`
`sudo pacman -S plymouth-theme-manjaro-gnome`
`sudo pacman -S plymouth-theme-manjaro-gnome-17.0`
`sudo pacman -S plymouth-theme-manjaro-redefined-bsplash`
`sudo pacman -S plymouth-theme-manjaro-very-elegant`
