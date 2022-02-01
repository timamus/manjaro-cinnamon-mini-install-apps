#!/usr/bin/env bash

set -Eeuo pipefail

# Installing transmission
echo -en "\033[1;33m Installing transmission... \033[0m \n"
sudo pacman -S --noconfirm transmission-gtk

# Installing veracrypt
echo -en "\033[1;33m Installing veracrypt... \033[0m \n"
sudo pacman -S --noconfirm veracrypt

# Installing remmina with rdp and vnc plugins
echo -en "\033[1;33m Installing remmina with rdp and vnc plugins... \033[0m \n"
sudo pacman -S --noconfirm remmina freerdp libvncserver

# Installing gimp with help
echo -en "\033[1;33m Installing gimp with help... \033[0m \n"
sudo pacman -S --noconfirm gimp gimp-help-ru

# Installing shotcut
echo -en "\033[1;33m Installing shotcut... \033[0m \n"
sudo pacman -S --noconfirm shotcut

# Installing smplayer with skins
echo -en "\033[1;33m Installing smplayer with skins and themes... \033[0m \n"
sudo pacman -S --noconfirm smplayer smplayer-skins smplayer-themes
smplayer -delete-config
smplayer &
echo "Waiting for 5 seconds for smplayer to open..."
sleep 5s
smplayer -send-action close
echo "Waiting for 5 seconds for smplayer to close..."
sleep 5s
sed -i 's/^\(gui\s*=\s*\).*$/\1MiniGUI/' $HOME/.config/smplayer/smplayer.ini
sed -i 's/^\(iconset\s*=\s*\).*$/\1PapirusDark/' $HOME/.config/smplayer/smplayer.ini
sed -i 's/^\(qt_style\s*=\s*\).*$/\1kvantum-dark/' $HOME/.config/smplayer/smplayer.ini

# Installing firefox
echo -en "\033[1;33m Installing firefox... \033[0m \n"
sudo pacman -S --noconfirm firefox

# Deleting midori browser and all the dependencies
echo -en "\033[1;33m Deleting midori browser and all the dependencies... \033[0m \n"
if pacman -Qs midori > /dev/null ; then
  sudo pacman -Rcns midori
fi
if [ -d "$HOME/.config/midori" ] 
then
  rm -R $HOME/.config/midori
fi
if [ -d "$HOME/.cache/midori" ] 
then
  rm -R $HOME/.cache/midori
fi
if [ -d "$HOME/.local/share/zeitgeist" ] 
then
  rm -R $HOME/.local/share/zeitgeist
fi

# Installing telegram
echo -en "\033[1;33m Installing telegram... \033[0m \n"
sudo pacman -S --noconfirm telegram-desktop

# Installing bitwarden
echo -en "\033[1;33m Installing bitwarden... \033[0m \n"
sudo pacman -S --noconfirm bitwarden

# Installing goldendict
echo -en "\033[1;33m Installing goldendict... \033[0m \n"
sudo pacman -S --noconfirm goldendict

# Installing libreoffice with russian language pack
echo -en "\033[1;33m Installing libreoffice with russian language pack... \033[0m \n"
sudo pacman -S --noconfirm libreoffice-still libreoffice-still-ru

# Installing MS Windows 10 21H2 Build fonts from a local folder
echo -en "\033[1;33m Installing MS Windows 10 21H2 Build fonts from a local folder... \033[0m \n"
sudo pacman -U --noconfirm ttf-ms-win10-10.0.19043.1055-1-any.pkg.tar.zst

# Installing yay – AUR Helper
echo -en "\033[1;33m Installing yay – AUR Helper... \033[0m \n"
sudo pacman -S --noconfirm yay

# Installing ProtonVPN from AUR (it is needed first if resources are not available for downloading sources for building packages from AUR. For example, the mirrors of the sourceforge.net resource were unavailable)
echo -en "\033[1;33m Installing ProtonVPN from AUR... \033[0m \n"
yay -S --noconfirm protonvpn

# Installing luckybackup from AUR
echo -en "\033[1;33m Installing luckybackup from AUR... \033[0m \n"
yay -S --noconfirm luckybackup

# Installing yandex-disk-indicator from AUR
echo -en "\033[1;33m Installing yandex-disk-indicator from AUR... \033[0m \n"
yay -S --noconfirm yandex-disk-indicator

# Installing steam from flatpak repo
echo -en "\033[1;33m Installing steam from flatpak repo... \033[0m \n"
sudo flatpak install flathub com.valvesoftware.Steam

echo -en "\033[0;35m Installation successfull \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
