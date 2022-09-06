#!/usr/bin/env bash

CURRENT_DIR=$( dirname -- "$0"; )
USERDIR="/home/user"

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
echo "installing simplenote brightnessctl imlib2"
yay -S simplenote-electron-bin brightnessctl imlib2

echo "installing user scripts"
echo "installing onliddown.sh"
cp $CURRENT_DIR/onliddown.sh /usr/local/bin/onliddown.sh
chmod +x /usr/local/bin/onliddown.sh
echo "installing swkboard.sh"
cp $CURRENT_DIR/swkboard.sh /usr/local/bin/swkboard.sh
chmod +x /usr/local/bin/swkboard.sh
echo "installing runnotifier.sh"
cp $CURRENT_DIR/runnotifier.sh /usr/local/bin/runnotifier.sh
chmod +x /usr/local/bin/runnotifier.sh
echo "installing onstart.sh"
cp $CURRENT_DIR/onstart.sh /usr/local/bin/onstart.sh
chmod +x /usr/local/bin/onstart.sh

echo "installing alacritty"
yay -S alacritty
mkdir $USERDIR/.config/alacritty
cp $CURRENT_DIR/alacritty.yml $USERDIR/.config/alacritty/alacritty.yml

echo "cloning dwm-flexipatch to $HOME"
git clone https://github.com/bakkeby/dwm-flexipatch $USERDIR/dwm-flexipatch
DWM_DIR=$USERDIR/dwm-flexipatch
echo "installing dwm flexipatch"
make install -C $DWM_DIR
echo "making backup for config.h"
cp $DWM_DIR/config.h $DWM_DIR/config.h.backup
echo "making backup for patches.h"
cp $DWM_DIR/config.h $DWM_DIR/pathces.h.backup
echo "replacing config.mk"
cp $CURRENT_DIR/config.mk $DWM_DIR/config.mk
echo "replacing config.h"
cp $CURRENT_DIR/config.h $DWM_DIR/config.h
echo "replacing patches.h"
cp $CURRENT_DIR/patches.h $DWM_DIR/patches.h
echo "create dir for dwm-autostart"
mkdir $USERDIR/.local/share/dwm
echo "create dwm-autostart"
cp $CURRENT_DIR/autostart.sh $USERDIR/.local/share/dwm/autostart.sh
echo "installing dwm"
make install -C $DWM_DIR

echo "installing nerd fonts and powerline fonts"
yay -S powerline-fonts ttf-nerd-fonts-symbols-1000-em

echo "generating ranger configs"
ranger --copy-config=all
echo "replacing rc.conf"
cp $CURRENT_DIR/rc.conf $USERDIR/.config/ranger/rc.conf
echo "replacing rc.conf for root"
cp $CURRENT_DIR/rc.conf /root/.config/ranger/rc.conf
echo "creating directory for ranger plugins"
mkdir $USERDIR/.config/ranger/plugins
echo "installing ranger devicons plugin"
git clone https://github.com/alexanderjeurissen/ranger_devicons $USERDIR/.config/ranger/plugins/ranger_devicons

echo "installing fish and oh-my-fish with bobthefish nord theme"
yay -S fish
# curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install
# omf install bobthefish # can not use omf from bash
echo "set theme_color_scheme nord" >> $USERDIR/.config/fish/conf.d/omf.fish
echo "fish" >> ~/.bashrc
echo "done"
