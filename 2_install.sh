#!/bin/bash

# Installing gnome-calculator
echo "Installing gnome-calculator"
sudo pacman -S gnome-calculator

# Installing nemo-fileroller
echo "Installing nemo-fileroller"
sudo pacman -S nemo-fileroller

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

echo "Installation successfull"
read -rsn1 -p"Press any key to exit";echo
