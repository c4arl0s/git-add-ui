#!/bin/bash
INPUT=/etc/hosts
let i=0 # define counting variable
W=() # define working array
while read -r addr line; do # process file by file
  let i=$i+1
  W+=($addr "$i $line")
done < <( sed -e '1,/# ETHERNET SWITCHES/d' -e '/# END SWITCHES/,9999d' $INPUT )
FILE=$(dialog --stdout --no-tags --title "List of Switches in /etc/hosts file" --menu "Chose one" 24 80 17 "${W[@]}" ) # show dialog and store output
clear
if [ $? -eq 0 ]; then # Exit with OK
  ssh $FILE
fi
