#!/usr/bin/env bash

CURRENT_DIR=$( dirname -- "$0"; )
USERDIR="/home/user"
DOWNLDSDIR="/home/user/Downloads"

exec &> >(tee  $CURRENT_DIR/recover.log)

echo "refreshing keys"
pacman -Sy archlinux-keyring
echo "updating"
yay -Syu
echo "installing necessary packages"
echo "installing xorg slock base-devel libx11 libxinerama libxft git vim webkit2gtk dbus libconfig mesa pcre2 libevdev uthash meson ninja acpi sysstat"
yay -S xorg slock base-devel libx11 libxinerama libxft git vim webkit2gtk dbus libconfig mesa pcre2 libevdev uthash meson ninja acpi sysstat
echo "installing twmn-git ranger atool unrar 7z pdftotext mupdf-tools perl-exiftool odt2txt pandoc python-xlsx2csv w3m lynx elinks jq mediainfo fontforge imagemagick antiword djvulibre udiskie"
yay -S twmn-git ranger atool unrar 7z pdftotext mupdf-tools perl-exiftool odt2txt pandoc python-xlsx2csv w3m lynx elinks jq mediainfo fontforge imagemagick antiword djvulibre udiskie
echo "installing simplenote brightnessctl imlib2 geany libxext libxcb pixman network-manager-applet python-pip python2 conky"
yay -S simplenote-electron-bin brightnessctl imlib2 geany libxext libxcb pixman network-manager-applet python-pip python2 conky

echo "installing configs for twmn"
cp $CURRENT_DIR/twmn.conf $USERDIR/.config/twmn/twmn.conf

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
echo "installing statusbar.sh"
cp $CURRENT_DIR/statusbar.sh /usr/local/bin/statusbar.sh
chmod +x /usr/local/bin/statusbar.sh
echo "installing downloadnewwp.sh"
cp $CURRENT_DIR/downloadnewwp.sh /usr/local/bin/downloadnewwp.sh
chmod +x /usr/local/bin/downloadnewwp.sh
echo "installing upwp.sh"
cp $CURRENT_DIR/upwp.sh /usr/local/bin/upwp.sh
chmod +x /usr/local/bin/upwp.sh
echo "installing upwp_once.sh"
cp $CURRENT_DIR/upwp_once.sh /usr/local/bin/upwp_once.sh
chmod +x /usr/local/bin/upwp_once.sh
echo "installing colorpicker.sh"
cp $CURRENT_DIR/colorpicker.sh /usr/local/bin/colorpicker.sh
chmod +x /usr/local/bin/colorpicker.sh
echo "installing color2x.py"
cp $CURRENT_DIR/color2x.py ~/color2x.py
echo "installing user-defined.conkyrc"
cp $CURRENT_DIR/user-defined.conkyrc ~/.config/conky/user-defined.conkyrc

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

echo "installing picom"
git clone https://github.com/pijulius/picom $DOWNLDSDIR/picom
echo "entering picom dir"
cd $DOWNLDSDIR/picom
git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build install
cd $CURRENT_DIR

echo "initializing .xsession"
echo "swkboard.sh" >> $USERDIR/.xsession
echo "picom -b --animations --animation-window-mass 0.8 --animation-for-open-window zoom --backend xr_glx_hybrid --opacity-rule '100:name *?= \"twmn\"' --fade-exclude 'name *?= \"twmn\"'" >> $USERDIR/.xsession
#echo "picom -b --animations --animation-window-mass 0.8 --animation-for-open-window zoom --backend xr_glx_hybrid" >> $USERDIR/.xsession
echo "udiskie&" >> $USERDIR/.xsession
echo "twmnd&" >> $USERDIR/.xsession
echo "onliddown.sh&" >> $USERDIR/.xsession
echo "nm-applet.sh&" >> $USERDIR/.xsession
echo "statusbar.sh&" >> $USERDIR/.xsession
echo "uwp.sh&" >> $USERDIR/.xsession
echo "conky -c ~/.config/conky/config.conkyrc&" >> $USERDIR/.xsession

echo "installing fish and oh-my-fish with bobthefish nord theme"
yay -S fish
# curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install
# omf install bobthefish # can not use omf from bash
echo "set theme_color_scheme nord" >> $USERDIR/.config/fish/conf.d/omf.fish
echo "fish" >> $USERDIR/.bashrc
echo "done"
