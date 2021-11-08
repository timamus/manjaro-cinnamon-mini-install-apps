#!/bin/bash

# Installing gnome-system-monitor
# https://unix.stackexchange.com/questions/174683/custom-global-keybindings-in-cinnamon-via-gsettings
echo "Installing gnome-system-monitor"
sudo pacman -S gnome-system-monitor
gsettings set org.cinnamon.desktop.keybindings custom-list \ "['custom0']"
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/ name "System monitor"
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/ command "gnome-system-monitor"
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/ binding "['<Primary><Shift><Ctrl>Escape']"

# Installing baobab
echo "Installing baobab"
sudo pacman -S baobab

# Installing gparted
echo "Installing gparted"
sudo pacman -S gparted

# Installing mintstick
echo "Installing mintstick"
sudo pacman -S mintstick

# Installing gnome-calculator
echo "Installing gnome-calculator"
sudo pacman -S gnome-calculator

# Installing nemo-fileroller
echo "Installing nemo-fileroller"
sudo pacman -S nemo-fileroller

# Installing xviewer with plugins
echo "Installing xviewer with plugins"
sudo pacman -S xviewer xviewer-plugins

# Installing gprename
echo "Installing gprename"
sudo pacman -S gprename

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

echo "Installation successfull"
read -rsn1 -p"Press any key to exit";echo
