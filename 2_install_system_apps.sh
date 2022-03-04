#!/usr/bin/env bash

set -Eeuo pipefail

# Installing timeshift
echo -en "\033[1;33m Installing timeshift... \033[0m \n"
sudo pacman -S --noconfirm timeshift

# Installing yay – AUR Helper
echo -en "\033[1;33m Installing yay – AUR Helper... \033[0m \n"
sudo pacman -S --noconfirm yay

# Installing debtap
echo -en "\033[1;33m Installing debtap from AUR... \033[0m \n"
yay -S --noconfirm debtap
# Updating debtap database
sudo debtap -u

# Installing gufw
echo -en "\033[1;33m Installing gufw... \033[0m \n"
sudo pacman -S --noconfirm gufw

# Start and enable ufw
echo -en "\033[1;33m Start and enable ufw... \033[0m \n"
sudo systemctl start ufw
sudo systemctl enable ufw
sudo ufw default allow outgoing
sudo ufw default deny incoming
sudo ufw enable

# Installing dconf-editor
echo -en "\033[1;33m Installing dconf-editor... \033[0m \n"
sudo pacman -S --noconfirm dconf-editor

# Installing gnome-system-monitor
# https://unix.stackexchange.com/questions/174683/custom-global-keybindings-in-cinnamon-via-gsettings
echo -en "\033[1;33m Installing gnome-system-monitor... \033[0m \n"
sudo pacman -S --noconfirm gnome-system-monitor
gsettings set org.cinnamon.desktop.keybindings custom-list \ "['custom0']"
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/ name "System monitor"
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/ command "gnome-system-monitor"
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/ binding "['<Primary><Shift><Ctrl>Escape']"

# Installing baobab
echo -en "\033[1;33m Installing baobab... \033[0m \n"
sudo pacman -S --noconfirm baobab

# Installing gnome-disk-utility
echo -en "\033[1;33m Installing gnome-disk-utility... \033[0m \n"
sudo pacman -S --noconfirm gnome-disk-utility

# Installing gnome-font-viewer
echo -en "\033[1;33m Installing gnome-font-viewer... \033[0m \n"
sudo pacman -S --noconfirm gnome-font-viewer

# Installing mintstick
echo -en "\033[1;33m Installing mintstick... \033[0m \n"
sudo pacman -S --noconfirm mintstick

# Installing gnome-calculator
echo -en "\033[1;33m Installing gnome-calculator... \033[0m \n"
sudo pacman -S --noconfirm gnome-calculator

# Installing nemo-fileroller
echo -en "\033[1;33m Installing nemo-fileroller... \033[0m \n"
sudo pacman -S --noconfirm nemo-fileroller p7zip unrar unace lrzip

# Installing xviewer with plugins
echo -en "\033[1;33m Installing xviewer with plugins... \033[0m \n"
sudo pacman -S --noconfirm xviewer xviewer-plugins

# Installing xreader with support for djvu files
echo -en "\033[1;33m Installing xreader with support for djvu files... \033[0m \n"
sudo pacman -S --noconfirm xreader djvulibre

# Installing gnome-screenshot
echo -en "\033[1;33m Installing gnome-screenshot... \033[0m \n"
sudo pacman -S --noconfirm gnome-screenshot

# Installing gprename
# echo -en "\033[1;33m Installing gprename... \033[0m \n"
# sudo pacman -S --noconfirm gprename

# Installing bulky is similar to gprename from the Linux Mint distribution
echo -en "\033[1;33m Installing bulky... \033[0m \n"
sudo pacman -S --noconfirm bulky

# Installing gnome-calendar
echo -en "\033[1;33m Installing gnome-calendar... \033[0m \n"
sudo pacman -S --noconfirm gnome-calendar

# Installing blueberry for bluetooth support
echo -en "\033[1;33m Installing blueberry for bluetooth support... \033[0m \n"
sudo pacman -S --noconfirm blueberry

echo -en "\033[0;35m Installation successfull \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
