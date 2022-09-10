#! /bin/bash

get_image() {
	tempip=$(echo $(curl -m 1 ifconfig.me))
	re='^[0-9]+$'
	if ! [[ "${tempip: 0:1}" =~ $re ]] ; then
		CONNECTED=false
	else
		CONNECTED=true
	fi

	if [ $CONNECTED = true ]; then
		IMGPATH=$(downloadnewwp.sh)
	else
		IMGPATH=$(find $WPATH -type f | shuf -n 1)
	fi
}

WPATH=${WALLPAPER_PATH:-"$HOME/Pictures/Wallpapers"}
mkdir -p $WPATH

get_image
~/.local/bin/wal -i $IMGPATH -s
python3 /home/user/color2x.py 
xrdb -merge /home/user/.Xresources 
xdotool key shift+Super+F5
pywalfox update
