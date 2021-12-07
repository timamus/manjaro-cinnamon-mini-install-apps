# manjaro-cinnamon-mini-install-apps
Manjaro cinnamon minimal installation apps scripts

## Link for readme file

- `https://raw.githubusercontent.com/timamus/manjaro-cinnamon-mini-install-apps/main/README.md`

## Quick start

- `git clone https://github.com/timamus/manjaro-cinnamon-mini-install-apps.git`
- `cd manjaro-cinnamon-mini-install-apps/`
- `find ./ -name "*.sh" -exec chmod +x {} \;`
- `./1_system_upgrade.sh`
- `./2_install_system_apps.sh`
- `./3_install_main_apps.sh`
- `./4_install_develop_apps.sh`

## Adding and changing the keyboard layout

- `gsettings set org.gnome.libgnomekbd.keyboard layouts "['us', 'ru']"`
- `gsettings set org.cinnamon.desktop.interface keyboard-layout-use-upper true`

## Changing default fonts in the system

- `gsettings set org.cinnamon.desktop.interface font-name "Ubuntu 10"`
- `gsettings set org.nemo.desktop font "Ubuntu 10"`
- `gsettings set org.cinnamon.desktop.wm.preferences titlebar-font "Ubuntu Semi-Bold 10"`

## Firefox Options

Addons:

- https://addons.mozilla.org/ru/firefox/addon/adblocker-ultimate/
- https://addons.mozilla.org/ru/firefox/addon/bitwarden-password-manager/
- https://addons.mozilla.org/ru/firefox/addon/new-tab-suspender/
- https://addons.mozilla.org/ru/firefox/addon/musicpro/

## Battery Applet with Monitoring and Shutdown (BAMS)

Install the BAMS applet, then run:

- `mkdir /$HOME/batterymonitor@pdcurtis`
- `cp /$HOME/.local/share/cinnamon/applets/batterymonitor@pdcurtis/stylesheet.css /$HOME/batterymonitor@pdcurtis`
- `sed -i -e '9 s/rgba(0,255,0,0.3)/rgba(0,0,0,0.1)/' -e '13 s/rgba(0,255,0,0.5)/rgba(0,0,0,0.1)/' /$HOME/batterymonitor@pdcurtis/stylesheet.css`

Install dependencies:

- `sudo pacman -S upower sox zenity`

Then, in the applet settings, select the option 'Compact - Battery Percentage without extended messages' in the 'Display Mode' area
