#!/bin/bash

# Installing telegram
echo "Installing telegram"
sudo pacman -S telegram-desktop

# Installing bitwarden
echo "Installing bitwarden"
sudo pacman -S bitwarden

# Installing firefox
echo "Installing firefox"
sudo pacman -S firefox

firefox &
sleep 10 & PID=$!
printf "Waiting for firefox to create a user profile ["
while kill -0 $PID 2> /dev/null; do
 printf  "."
 sleep 1
done
printf "] ";echo

sudo pkill -f firefox

# Configration firefox
section=Profile0
var=Path
profile_name=$(awk -F"=" -v section=$section -v var=$var '$1=="["section"]"{secFound=1}secFound==1 && $1==var{print $2; secFound=0}' /home/$USER/.mozilla/firefox/profiles.ini) # Get name user's profile name
echo $profile_name

# Installing libreoffice with russian language pack
echo "Installing libreoffice with russian language pack"
sudo pacman -S libreoffice-still libreoffice-still-ru

# Installing steam from flatpak repo
echo "Installing steam from flatpak repo"
sudo flatpak install flathub com.valvesoftware.Steam

echo "Installation successfull"
read -rsn1 -p"Press any key to exit";echo
