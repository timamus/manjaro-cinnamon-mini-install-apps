#!/usr/bin/env bash

# Installing rider from flatpak repo
#echo -en "\033[1;33m Installing rider from flatpak repo... \033[0m \n"
#sudo flatpak install flathub com.jetbrains.Rider

# Installing mono
sudo pacman -S --noconfirm mono

# Installing dotnet
yay -S rider dotnet-sdk-bin

# Installing rider
yay -S rider xamarin-android

NodeJS
VSCode
DBeawer
PyCharm
Dotnet
