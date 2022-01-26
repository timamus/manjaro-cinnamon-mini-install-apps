#!/usr/bin/env bash

set -Eeuo pipefail

# Installing transmission
echo -en "\033[1;33m Installing transmission... \033[0m \n"
sudo pacman -S transmission-gtk --noconfirm

# Installing veracrypt
echo -en "\033[1;33m Installing veracrypt... \033[0m \n"
sudo pacman -S veracrypt --noconfirm

# Installing remmina with rdp and vnc plugins
echo -en "\033[1;33m Installing remmina with rdp and vnc plugins... \033[0m \n"
sudo pacman -S remmina freerdp libvncserver --noconfirm

# Installing gimp with help
echo -en "\033[1;33m Installing gimp with help... \033[0m \n"
sudo pacman -S gimp gimp-help-ru --noconfirm

# Installing shotcut
echo -en "\033[1;33m Installing shotcut... \033[0m \n"
sudo pacman -S shotcut --noconfirm

# Installing smplayer with skins
echo -en "\033[1;33m Installing smplayer with skins and themes... \033[0m \n"
sudo pacman -S smplayer smplayer-skins smplayer-themes --noconfirm
sed -i 's/^\(gui\s*=\s*\).*$/\1MiniGUI/' /$HOME/.config/smplayer/smplayer.ini
sed -i 's/^\(iconset\s*=\s*\).*$/\1PapirusDark/' /$HOME/.config/smplayer/smplayer.ini
sed -i 's/^\(qt_style\s*=\s*\).*$/\1kvantum-dark/' /$HOME/.config/smplayer/smplayer.ini

# Installing firefox
echo -en "\033[1;33m Installing firefox... \033[0m \n"
sudo pacman -S firefox --noconfirm

# Deleting midori browser and all the dependencies
echo -en "\033[1;33m Deleting midori browser and all the dependencies... \033[0m \n"
sudo pacman -Rcns midori
rm -R /home/$USER/.config/midori
rm -R /home/$USER/.cache/midori
rm -R /home/$USER/.local/share/zeitgeist

# Installing telegram
echo -en "\033[1;33m Installing telegram... \033[0m \n"
sudo pacman -S telegram-desktop --noconfirm

# Installing bitwarden
echo -en "\033[1;33m Installing bitwarden... \033[0m \n"
sudo pacman -S bitwarden --noconfirm

# Installing libreoffice with russian language pack
echo -en "\033[1;33m Installing libreoffice with russian language pack... \033[0m \n"
sudo pacman -S libreoffice-still libreoffice-still-ru --noconfirm

# Installing steam from flatpak repo
echo -en "\033[1;33m Installing steam from flatpak repo... \033[0m \n"
sudo flatpak install flathub com.valvesoftware.Steam

# Installing luckybackup from AUR
echo -en "\033[1;33m Installing luckybackup from AUR... \033[0m \n"
pamac build luckybackup

# Installing ProtonVPN from AUR
echo -en "\033[1;33m Installing ProtonVPN from AUR... \033[0m \n"
pamac build protonvpn

echo -en "\033[0;35m Installation successfull \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
