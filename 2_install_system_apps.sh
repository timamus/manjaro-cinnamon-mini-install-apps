#!/usr/bin/env bash

set -Eeuo pipefail

# Installing timeshift
echo -en "\033[1;33m Installing timeshift... \033[0m \n"
sudo pacman -S timeshift --noconfirm

# Installing gufw
echo -en "\033[1;33m Installing gufw... \033[0m \n"
sudo pacman -S gufw --noconfirm

# Installing dconf-editor
echo -en "\033[1;33m Installing dconf-editor... \033[0m \n"
sudo pacman -S dconf-editor --noconfirm

# Installing gnome-system-monitor
# https://unix.stackexchange.com/questions/174683/custom-global-keybindings-in-cinnamon-via-gsettings
echo -en "\033[1;33m Installing gnome-system-monitor... \033[0m \n"
sudo pacman -S gnome-system-monitor --noconfirm
gsettings set org.cinnamon.desktop.keybindings custom-list \ "['custom0']"
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/ name "System monitor"
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/ command "gnome-system-monitor"
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/ binding "['<Primary><Shift><Ctrl>Escape']"

# Installing baobab
echo -en "\033[1;33m Installing baobab... \033[0m \n"
sudo pacman -S baobab --noconfirm

# Installing gnome-disk-utility
echo -en "\033[1;33m Installing gnome-disk-utility... \033[0m \n"
sudo pacman -S gnome-disk-utility --noconfirm

# Installing gnome-font-viewer
echo -en "\033[1;33m Installing gnome-font-viewer... \033[0m \n"
sudo pacman -S gnome-font-viewer --noconfirm

# Installing mintstick
echo -en "\033[1;33m Installing mintstick... \033[0m \n"
sudo pacman -S mintstick --noconfirm

# Installing gnome-calculator
echo -en "\033[1;33m Installing gnome-calculator... \033[0m \n"
sudo pacman -S gnome-calculator --noconfirm

# Installing nemo-fileroller
echo -en "\033[1;33m Installing nemo-fileroller... \033[0m \n"
sudo pacman -S nemo-fileroller --noconfirm

# Installing xviewer with plugins
echo -en "\033[1;33m Installing xviewer with plugins... \033[0m \n"
sudo pacman -S xviewer xviewer-plugins --noconfirm

# Installing xreader with support for djvu files
echo -en "\033[1;33m Installing xreader with support for djvu files... \033[0m \n"
sudo pacman -S xreader djvulibre --noconfirm

# Installing gnome-screenshot
echo -en "\033[1;33m Installing gnome-screenshot... \033[0m \n"
sudo pacman -S gnome-screenshot --noconfirm

# Installing gprename
echo -en "\033[1;33m Installing gprename... \033[0m \n"
sudo pacman -S gprename --noconfirm

echo -en "\033[0;35m Installation successfull \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
