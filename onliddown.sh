#! /bin/bash

close="close"

while true
do
	state=$(cat /proc/acpi/button/lid/LID/state)
	state="${state: 12}"
	close="closed"

	if [ "$state" = "$close" ]; then
   	 	systemctl hibernate && slock
	fi
	sleep 0.1

done