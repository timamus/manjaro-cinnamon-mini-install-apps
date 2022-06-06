#!/usr/bin/env bash

set -Eeuo pipefail

# Installing nodejs & npm. Npm is needed for xamarin-android
echo -en "\033[1;33m Installing nodejs & npm... \033[0m \n"
sudo pacman -S --noconfirm nodejs npm
npm config set prefix ~/.npm-packages

# Installing mono
echo -en "\033[1;33m Installing mono... \033[0m \n"
sudo pacman -S --noconfirm mono

# Installing dotnet-sdk from AUR
echo -en "\033[1;33m Installing dotnet-sdk from AUR... \033[0m \n"
yay -S --noconfirm dotnet-sdk-bin aspnet-runtime-bin

# Installing pv - monitor the progress of data through a pipe. Needed for xamarin-android
# echo -en "\033[1;33m Installing pv - monitor the progress of data through a pipe... \033[0m \n"
# sudo pacman -S --noconfirm pv

# Installing xamarin-android from AUR (not working at the moment, read the file xamarin-android.md)
# echo -en "\033[1;33m Installing xamarin-android from AUR... \033[0m \n"
# cd $HOME/.cache/yay/
# yay -G xamarin-android
# cd $HOME/.cache/yay/xamarin-android
# Fix some bug with not found _cleanup command in PKGBUILD file
# sed -i 's/_cleanup/# _cleanup/' PKGBUILD
# makepkg -si --noconfirm
# cd $HOME/

# Installing rider from flatpak repo
# echo -en "\033[1;33m Installing rider from flatpak repo... \033[0m \n"
# sudo flatpak install flathub com.jetbrains.Rider

# Installing rider from AUR
echo -en "\033[1;33m Installing rider from AUR... \033[0m \n"
yay -S --noconfirm rider
# Excluded from the upgrade packages. It weighs too much, for constant updating
sudo sed -i '/IgnorePkg = rider/d' /etc/pacman.conf
sudo sed -i '/^#IgnoreGroup.*/i IgnorePkg = rider' /etc/pacman.conf

sudo sed -i '/1.2.3.4 account.jetbrains.com/d' /etc/hosts
sudo bash -c "echo 1.2.3.4 account.jetbrains.com >> /etc/hosts"

# Installing pycharm professional edition
echo -en "\033[1;33m Installing pycharm professional edition from AUR... \033[0m \n"
yay -S --noconfirm pycharm-professional
# Excluded from the upgrade packages. It weighs too much, for constant updating
sudo sed -i '/IgnorePkg = pycharm-professional/d' /etc/pacman.conf
sudo sed -i '/^#IgnoreGroup.*/i IgnorePkg = pycharm-professional' /etc/pacman.conf

# Installing pycharm community edition
# echo -en "\033[1;33m Installing pycharm community edition... \033[0m \n"
# sudo pacman -S --noconfirm pycharm-community-edition

# Installing intellij idea ultimate edition
echo -en "\033[1;33m Installing intellij idea ultimate edition from AUR... \033[0m \n"
yay -S --noconfirm intellij-idea-ultimate-edition intellij-idea-ultimate-edition-jre
# Excluded from the upgrade packages. It weighs too much, for constant updating
sudo sed -i '/IgnorePkg = intellij-idea-ultimate-edition/d' /etc/pacman.conf
sudo sed -i '/^#IgnoreGroup.*/i IgnorePkg = intellij-idea-ultimate-edition' /etc/pacman.conf

# Installing clion from AUR
# Clion currently uses version 11 of Java, as does Pycharm.
# If Pycharm is not installed, then follow the steps below.
# First install it: sudo pacman -S jre11-openjdk
# Then run: sudo archlinux-java set java-11-openjdk
# echo -en "\033[1;33m Installing clion from AUR... \033[0m \n"
# yay -S --noconfirm clion clion-cmake clion-gdb clion-lldb

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
