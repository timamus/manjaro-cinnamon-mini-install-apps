#!/usr/bin/env bash

set -Eeuo pipefail

# Installing mono
echo -en "\033[1;33m Installing mono... \033[0m \n"
sudo pacman -S --noconfirm mono

# Installing dotnet-sdk from AUR
echo -en "\033[1;33m Installing dotnet-sdk from AUR... \033[0m \n"
yay -S --noconfirm dotnet-sdk-bin

# Installing rider from flatpak repo
# echo -en "\033[1;33m Installing rider from flatpak repo... \033[0m \n"
# sudo flatpak install flathub com.jetbrains.Rider

# Installing rider & xamarin-android from AUR
echo -en "\033[1;33m Installing rider & xamarin-android from AUR... \033[0m \n"
yay -S --noconfirm rider xamarin-android

sudo sed -i '/1.2.3.4 account.jetbrains.com/d' /etc/hosts
sudo bash -c "echo 1.2.3.4 account.jetbrains.com >> /etc/hosts"

# Installing pycharm community edition
echo -en "\033[1;33m Installing pycharm community edition... \033[0m \n"
sudo pacman -S --noconfirm pycharm-community-edition

# Installing nodejs & npm
echo -en "\033[1;33m Installing nodejs & npm... \033[0m \n"
sudo pacman -S --noconfirm nodejs npm

# Installing visual studio code from AUR
echo -en "\033[1;33m Installing visual studio code from AUR... \033[0m \n"
yay -S --noconfirm visual-studio-code-bin

# Installing dbeaver with plugins
echo -en "\033[1;33m Installing dbeaver with plugins... \033[0m \n"
sudo pacman -S --noconfirm dbeaver dbeaver-plugin-office dbeaver-plugin-svg-format

# Installing postman from AUR
echo -en "\033[1;33m Installing postman from AUR... \033[0m \n"
yay -S --noconfirm postman-bin

echo -en "\033[0;35m Installation successfull \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
