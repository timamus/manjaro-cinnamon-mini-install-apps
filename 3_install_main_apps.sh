#!/bin/bash

# Installing transmission
echo "Installing transmission"
sudo pacman -S transmission-gtk

# Installing veracrypt
echo "Installing veracrypt"
sudo pacman -S veracrypt

# Installing remmina with rdp and vnc plugins
echo "Installing remmina with rdp and vnc plugins"
sudo pacman -S remmina freerdp libvncserver

# Installing gimp with help
echo "Installing gimp with help"
sudo pacman -S gimp gimp-help-ru

# Installing shotcut
echo "Installing shotcut"
sudo pacman -S shotcut

# Installing smplayer with skins
echo "Installing smplayer with skins and themes"
sudo pacman -S smplayer smplayer-skins smplayer-themes
sed -i 's/^\(gui\s*=\s*\).*$/\1MiniGUI/' /$HOME/.config/smplayer/smplayer.ini
sed -i 's/^\(iconset\s*=\s*\).*$/\1PapirusDark/' /$HOME/.config/smplayer/smplayer.ini
sed -i 's/^\(qt_style\s*=\s*\).*$/\1kvantum-dark/' /$HOME/.config/smplayer/smplayer.ini

# Installing firefox
echo "Installing firefox"
sudo pacman -S firefox

# Deleting midori browser and all the dependencies
echo "Deleting midori browser and all the dependencies"
sudo pacman -Rcns midori
rm -R /home/$USER/.config/midori
rm -R /home/$USER/.cache/midori
rm -R /home/$USER/.local/share/zeitgeist

# Installing telegram
echo "Installing telegram"
sudo pacman -S telegram-desktop

# Installing bitwarden
echo "Installing bitwarden"
sudo pacman -S bitwarden

# Installing libreoffice with russian language pack
echo "Installing libreoffice with russian language pack"
sudo pacman -S libreoffice-still libreoffice-still-ru

# Installing steam from flatpak repo
echo "Installing steam from flatpak repo"
sudo flatpak install flathub com.valvesoftware.Steam

# Installing luckybackup from AUR
echo "Installing luckybackup from AUR"
pamac build luckybackup

# Installing ProtonVPN from AUR
echo "Installing ProtonVPN from AUR"
pamac build protonvpn

echo "Installation successfull"
read -rsn1 -p"Press any key to exit";echo
