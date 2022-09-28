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
HISTORYPATH=$HOME/.cache/wplist.log
touch $HISTORYPATH
printf "%s" "$(cat $HISTORYPATH | tail -n 1000)" > $HISTORYPATH
echo "" >> $HISTORYPATH


while true
do
	get_image
	exists=$(grep "$IMGPATH" $HISTORYPATH)
	
	#if [ ! -z "$exists" ]; then
	#	if [ ! $CONNECTED ]; then
	#		~/.local/bin/wal -i $IMGPATH -s
	#		python3 /home/user/color2x.py 
	#		xrdb -merge /home/user/.Xresources 
	#		xdotool key shift+Super+F5
	#		pywalfox update
	#		# wal-telegram --wal
	#		echo "$IMGPATH" >> $HISTORYPATH
	#		break
	#	else
	#		echo "Connected and file exists: $IMGPATH"
	#		echo $exists
	#	fi
	#else
		~/.local/bin/wal -i $IMGPATH -s
		python3 /home/user/color2x.py 
		xrdb -merge /home/user/.Xresources 
		xdotool key shift+Super+F5
		pywalfox update
		# wal-telegram --wal
		echo "$IMGPATH" >> $HISTORYPATH
		break
	#fi
done
