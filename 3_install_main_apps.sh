#!/usr/bin/env bash

set -Eeuo pipefail

# Installing transmission
echo -en "\033[1;33m Installing transmission... \033[0m \n"
sudo pacman -S --noconfirm transmission-gtk

# Installing veracrypt
echo -en "\033[1;33m Installing veracrypt... \033[0m \n"
sudo pacman -S --noconfirm veracrypt

# Installing virtualbox
echo -en "\033[1;33m Installing virtualbox... Select linux*-virtualbox-host-modules, which matches the current kernel version listed below \033[0m \n"
mhwd-kernel -li && sudo pacman -S virtualbox
yay -S --noconfirm virtualbox-ext-oracle
sudo gpasswd -a $USER vboxusers

# Installing remmina with rdp and vnc plugins
echo -en "\033[1;33m Installing remmina with rdp and vnc plugins... \033[0m \n"
sudo pacman -S --noconfirm remmina freerdp libvncserver

# Installing gimp with help
echo -en "\033[1;33m Installing gimp with help... \033[0m \n"
sudo pacman -S --noconfirm gimp gimp-help-en

# Installing krita
echo -en "\033[1;33m Installing krita... \033[0m \n"
sudo pacman -S --noconfirm krita

# Installing inkscape
echo -en "\033[1;33m Installing inkscape... \033[0m \n"
sudo pacman -S --noconfirm inkscape

# Installing pix is an advanced image viewer and browser
echo -en "\033[1;33m Installing pix is an advanced image viewer and browser... \033[0m \n"
sudo pacman -S --noconfirm pix

# Installing shotcut
echo -en "\033[1;33m Installing shotcut... \033[0m \n"
sudo pacman -S --noconfirm shotcut

# Installing smplayer with skins
echo -en "\033[1;33m Installing smplayer with skins and themes... \033[0m \n"
sudo pacman -S --noconfirm smplayer smplayer-skins smplayer-themes
smplayer -delete-config
smplayer &
echo "Waiting for 5 seconds for smplayer to open..."
sleep 5s
smplayer -send-action close
echo "Waiting for 5 seconds for smplayer to close..."
sleep 5s
sed -i 's/^\(gui\s*=\s*\).*$/\1MiniGUI/' $HOME/.config/smplayer/smplayer.ini
sed -i 's/^\(iconset\s*=\s*\).*$/\1PapirusDark/' $HOME/.config/smplayer/smplayer.ini
sed -i 's/^\(qt_style\s*=\s*\).*$/\1kvantum-dark/' $HOME/.config/smplayer/smplayer.ini

# Installing rhythmbox
echo -en "\033[1;33m Installing rhythmbox... \033[0m \n"
sudo pacman -S --noconfirm rhythmbox

# Installing firefox
echo -en "\033[1;33m Installing firefox... \033[0m \n"
sudo pacman -S --noconfirm firefox firefox-i18n-en-us

# Deleting midori browser and all the dependencies
echo -en "\033[1;33m Deleting midori browser and all the dependencies... \033[0m \n"
if pacman -Qs midori > /dev/null ; then
  sudo pacman -Runs --noconfirm midori # https://www.reddit.com/r/archlinux/comments/ki9hmm/how_to_properly_removeuninstall_packagesapps_with/
fi
if [ -d "$HOME/.config/midori" ] 
then
  rm -R $HOME/.config/midori
fi
if [ -d "$HOME/.cache/midori" ] 
then
  rm -R $HOME/.cache/midori
fi
if [ -d "$HOME/.local/share/zeitgeist" ] 
then
  rm -R $HOME/.local/share/zeitgeist
fi

# Installing thunderbird
echo -en "\033[1;33m Installing thunderbird... \033[0m \n"
sudo pacman -S --noconfirm thunderbird thunderbird-i18n-en-us

# Installing telegram
echo -en "\033[1;33m Installing telegram... \033[0m \n"
sudo pacman -S --noconfirm telegram-desktop

# Installing bitwarden
echo -en "\033[1;33m Installing bitwarden... \033[0m \n"
sudo pacman -S --noconfirm bitwarden

# Installing goldendict-git
# echo -en "\033[1;33m Installing goldendict-git from AUR... \033[0m \n"
# yay -S --noconfirm goldendict-git

# Installing goldendict-git
echo -en "\033[1;33m Installing goldendict-git from local folder... \033[0m \n"
cd GoldenDict
sudo pacman -U --noconfirm libeb-4.4.3-4-x86_64.pkg.tar.xz libiconv-1.16-3-x86_64.pkg.tar.xz goldendict-git-1:1.5.0rc2.r505.g8acb288c-1-x86_64.pkg.tar.xz
cd ..

# Installing calibre
echo -en "\033[1;33m Installing calibre... \033[0m \n"
sudo pacman -S --noconfirm calibre

# Installing redshift
echo -en "\033[1;33m Installing redshift... \033[0m \n"
sudo pacman -S --noconfirm redshift

# Installing libreoffice with hunspell-en_us & hyphen-en packages
echo -en "\033[1;33m Installing libreoffice with hunspell-en_us & hyphen-en packages... \033[0m \n"
sudo pacman -S --noconfirm libreoffice-still hunspell-en_us hyphen-en

# Installing MS Windows 10 21H2 Build fonts from a local folder
echo -en "\033[1;33m Installing MS Windows 10 21H2 Build fonts from a local folder... \033[0m \n"
sudo pacman -U --noconfirm Fonts/ttf-ms-win10-10.0.19043.1055-1-any.pkg.tar.zst

# Installing ttf-jetbrains-mono
echo -en "\033[1;33m Installing ttf-jetbrains-mono... \033[0m \n"
sudo pacman -S --noconfirm ttf-jetbrains-mono

# Installing ttf-hack
echo -en "\033[1;33m Installing ttf-hack... \033[0m \n"
sudo pacman -S --noconfirm ttf-hack

# Installing ProtonVPN from AUR
echo -en "\033[1;33m Installing ProtonVPN from AUR... \033[0m \n"
yay -S --noconfirm protonvpn

# Installing luckybackup from AUR
echo -en "\033[1;33m Installing luckybackup from AUR... \033[0m \n"
yay -S --noconfirm luckybackup

# Installing yandex-disk-indicator from AUR
echo -en "\033[1;33m Installing yandex-disk-indicator from AUR... \033[0m \n"
yay -S --noconfirm yandex-disk-indicator

# Installing tor-browser from AUR
echo -en "\033[1;33m Installing tor-browser from AUR... \033[0m \n"
yay -S --noconfirm tor-browser

# Installing steam from flatpak repo
# echo -en "\033[1;33m Installing steam from flatpak repo... \033[0m \n"
# sudo flatpak install flathub com.valvesoftware.Steam

# Installing steam
# You can enable Proton in the Steam Client in Steam > Settings > Steam Play
echo -en "\033[1;33m Installing steam... \033[0m \n"
sudo pacman -S --noconfirm steam-manjaro

# Installing texstudio (there is also group texlive-lang if you need chinese, cyrillic, etc)
# The path to change the program language: Options > Configure Texstudio > General > Language
echo -en "\033[1;33m Installing texstudio... \033[0m \n"
sudo pacman -S --noconfirm texstudio texlive-most texlive-bin

# Install language packs if the system language is Russian
if [ $(locale | sed -n 's/^LANG=//p') == "ru_RU.UTF-8" ]; then
  sudo pacman -S --noconfirm firefox-i18n-ru thunderbird-i18n-ru gimp-help-ru libreoffice-still-ru hunspell-ru
  # Installing hyphen-ru from AUR
  echo -en "\033[1;33m Installing hyphen-ru from AUR... \033[0m \n"
  yay -S --noconfirm hyphen-ru
fi

echo -en "\033[0;35m Installation successfull \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
