#!/bin/bash

# Installing telegram
echo "Installing telegram"
sudo pacman -S telegram-desktop

# Installing bitwarden
echo "Installing bitwarden"
sudo pacman -S bitwarden

# Installing firefox
echo "Installing firefox"
sudo pacman -S firefox

# Installing libreoffice with russian language pack
echo "Installing libreoffice with russian language pack"
sudo pacman -S libreoffice-still libreoffice-still-ru

# Installing steam from flatpak repo
echo "Installing steam from flatpak repo"
sudo flatpak install flathub com.valvesoftware.Steam

echo "Installation successfull"
read -rsn1 -p"Press any key to exit";echo
