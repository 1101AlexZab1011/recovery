#! /bin/bash

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>~/logs/runnotifier.out 2>&1

isrunning () {
  status=$(systemctl --user status "$1" | grep Active)
  status="${status: 13:1}"
  if [ "$status" == "a" ]; then
    return 1
  else
    return 0
  fi
}

isrunning "twmnd"
status=$?
echo "starting runnotifier"
while [ $status -eq 0 ]
do
   isrunning "twmnd"
   status=$?
   echo "current twmnd status: $status"

   if ! [ $status -eq 1 ]; then
      echo "launching twmnd"
      systemctl --user start twmnd
      sleep 0.5
   fi
done
echo "twmnd is working"
