#!/usr/bin/env bash

# Installing rider from flatpak repo
#echo -en "\033[1;33m Installing rider from flatpak repo... \033[0m \n"
#sudo flatpak install flathub com.jetbrains.Rider

# Installing mono
sudo pacman -S --noconfirm mono

# Installing dotnet
yay -S dotnet-sdk-bin

# Installing rider
yay -S rider xamarin-android

# Installing pycharm community edition
sudo pacman -S --noconfirm pycharm-community-edition

# Installing nodejs & npm
sudo pacman -S --noconfirm nodejs npm

# Installing visual studio code
yay -S visual-studio-code-bin

# Installing dbeaver
sudo pacman -S --noconfirm dbeaver dbeaver-plugin-office dbeaver-plugin-svg-format
