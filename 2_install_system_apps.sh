#!/usr/bin/env bash

set -Eeuo pipefail

# Installing timeshift
-en "\033[1;33m Installing timeshift... \033[0m \n"
sudo pacman -S timeshift

# Installing gufw
echo "Installing gufw... \033[0m \n"
sudo pacman -S gufw

# Installing dconf-editor
echo "Installing dconf-editor... \033[0m \n"
sudo pacman -S dconf-editor

# Installing gnome-system-monitor
# https://unix.stackexchange.com/questions/174683/custom-global-keybindings-in-cinnamon-via-gsettings
echo "Installing gnome-system-monitor... \033[0m \n"
sudo pacman -S gnome-system-monitor
gsettings set org.cinnamon.desktop.keybindings custom-list \ "['custom0']"
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/ name "System monitor"
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/ command "gnome-system-monitor"
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/ binding "['<Primary><Shift><Ctrl>Escape']"

# Installing baobab
echo "Installing baobab... \033[0m \n"
sudo pacman -S baobab

# Installing gnome-disk-utility
echo "Installing gnome-disk-utility... \033[0m \n"
sudo pacman -S gnome-disk-utility

# Installing gnome-font-viewer
echo "Installing gnome-font-viewer... \033[0m \n"
sudo pacman -S gnome-font-viewer

# Installing mintstick
echo "Installing mintstick... \033[0m \n"
sudo pacman -S mintstick

# Installing gnome-calculator
echo "Installing gnome-calculator... \033[0m \n"
sudo pacman -S gnome-calculator

# Installing nemo-fileroller
echo "Installing nemo-fileroller... \033[0m \n"
sudo pacman -S nemo-fileroller

# Installing xviewer with plugins
echo "Installing xviewer with plugins... \033[0m \n"
sudo pacman -S xviewer xviewer-plugins

# Installing xreader with support for djvu files
echo "Installing xreader with support for djvu files... \033[0m \n"
sudo pacman -S xreader djvulibre

# Installing gnome-screenshot
echo "Installing gnome-screenshot... \033[0m \n"
sudo pacman -S gnome-screenshot

# Installing gprename
echo "Installing gprename... \033[0m \n"
sudo pacman -S gprename

echo -en "\033[0;35m Installation successfull \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
