#!/usr/bin/env bash

CURRENT_DIR=$( dirname -- "$0"; )

exec &> >(tee  $CURRENT_DIR/recover.log)

echo "refreshing keys"
pacman -Sy archlinux-keyring
echo "updating"
yay -Syu
echo "installing necessary packages"
echo "installing xorg stterm suckless-tools build-essential libx11-dev libxinerama-dev libxft-dev git vim libwebkit2gtk-4.0-dev "
yay -S xorg slock base-devel libx11 libxinerama libxft git vim webkit2gtk 
echo "installing twmn ranger bsdtar atool unrar 7z pdftotext mupdf-tools perl-exiftool odt2txt pandoc python-xlsx2csv w3m lynx elinks jq mediainfo fontforge imagemagick antiword djvutxt udiskie"
yay -S twmn-git ranger atool unrar 7z pdftotext mupdf-tools perl-exiftool odt2txt pandoc python-xlsx2csv w3m lynx elinks jq mediainfo fontforge imagemagick antiword djvulibre udiskie
echo "installing simplenote brightnessctl"
yay -S simplenote-electron-bin brightnessctl

echo "installing user scripts"
echo "installing onliddown.sh"
sudo cp $CURRENT_DIR/onliddown.sh /usr/local/bin/onliddown.sh
sudo chmod +x /usr/local/bin/onliddown.sh
echo "installing swithchlang.sh"
sudo cp $CURRENT_DIR/swkboard.sh /usr/local/bin/swkboard.sh
sudo chmod +x /usr/local/bin/swithchlang.sh
echo "installing runnotifier.sh"
sudo cp $CURRENT_DIR/runnotifier.sh /usr/local/bin/runnotifier.sh
sudo chmod +x /usr/local/bin/runnotifier.sh
echo "installing udiskie_check.sh"
sudo cp $CURRENT_DIR/udiskie_check.sh /usr/local/bin/udiskie_check.sh
sudo chmod +x /usr/local/bin/udiskie_check.sh
echo "installing onstart.sh"
sudo cp $CURRENT_DIR/onstart.sh /usr/local/bin/onstart.sh
sudo chmod +x /usr/local/bin/onstart.sh

echo "installing alacritty"
yay -S alacritty
sudo mkdir ~/.config/alacritty
sudo cp $CURRENT_DIR/alacritty.yml ~/.config/alacritty/alacritty.yml

echo "cloning dwm-flexipatch to $HOME"
git clone https://github.com/bakkeby/dwm-flexipatch $HOME/dwm-flexipatch
DWM_DIR=$HOME/dwm-flexipatch
echo "making backup for config.h"
sudo cp $DWM_DIR/config.h $DWM_DIR/config.h.backup
echo "making backup for patches.h"
sudo cp $DWM_DIR/config.h $DWM_DIR/pathces.h.backup
echo "replacing config.h"
cp $CURRENT_DIR/config.h $DWM_DIR/config.h
echo "replacing patches.h"
cp $CURRENT_DIR/patches.h $DWM_DIR/config.h
echo "create dir for dwm-autostart"
mkdir ~/.local/share/dwm
echo "create dwm-autostart"
cp $CURRENT_DIR/autostart.sh ~/.local/share/dwm/autostart.sh
echo "installing dwm"
make install -C $DWM_DIR

echo "installing nerd fonts and powerline fonts"
yay -S powerline-fonts nerd-fonts-completess

echo "generating ranger configs"
ranger --copy-config=all
echo "replacing rc.conf"
sudo cp $CURRENT_DIR/rc.conf ~/.config/ranger/rc.conf
echo "replacing rc.conf for root"
sudo cp $CURRENT_DIR/rc.conf /root/.config/ranger/rc.conf
echo "creating directory for ranger plugins"
sudo mkdir ~/.config/ranger/plugins
echo "installing ranger devicons plugin"
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons/

echo "installing fish and oh-my-fish with bobthefish nord theme"
yay -S fish
sudo curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
omf install bobthefish
sudo echo "set theme_color_scheme nord" >> ~/.config/fish/conf.d/omf.fish
sudo echo "fish" >> ~/.bashrc
echo "done"
