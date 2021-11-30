#!/bin/bash

# Change default fonts in system
echo "Change default fonts in system"
gsettings set org.cinnamon.desktop.interface font-name "Ubuntu 10"
gsettings set org.nemo.desktop font "Ubuntu 10"
gsettings set org.cinnamon.desktop.wm.preferences titlebar-font "Ubuntu Semi-Bold 10"

# Installing gufw
echo "Installing gufw"
sudo pacman -S gufw

# Installing dconf-editor
echo "Installing dconf-editor"
sudo pacman -S dconf-editor

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

# Installing gnome-disk-utility
echo "Installing gnome-disk-utility"
sudo pacman -S gnome-disk-utility

# Installing gnome-font-viewer
echo "Installing gnome-font-viewer"
sudo pacman -S gnome-font-viewer

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

# Installing xreader with support for djvu files
echo "Installing xreader with support for djvu files"
sudo pacman -S xreader djvulibre

# Installing gnome-screenshot
echo "Installing gnome-screenshot"
sudo pacman -S gnome-screenshot

# Installing gprename
echo "Installing gprename"
sudo pacman -S gprename

echo "Installation successfull"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
