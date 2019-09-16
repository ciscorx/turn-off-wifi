#!/bin/sh -e

sleep 60  # wait a minute to allow sync with time server
currenttime=$(date +%H:%M)
currentdayoftheweek=$(date +%a)
## turn off wifi on boot up if current datetime falls on scheduled off target, otherwise turn it on

if ([ "$currenttime" \> "21:00" ] || [ "$currenttime" \< "14:30" ]) && ([ "Sun" = "$currentdayoftheweek" ] || [ "Mon" = "$currentdayoftheweek" ] || [ "Tue" = "$currentdayoftheweek" ] || [ "Wed" = "$currentdayoftheweek" ] || [ "Thu" = "$currentdayoftheweek" ]); then
    /usr/bin/emacs24-x -Q -l /home/pi/scripts/disable_wifi.el	
elif [ "$currenttime" \< "14:30" ] && [ "Fri" = "$currentdayoftheweek" ] ; then
        /usr/bin/emacs24-x -Q -l /home/pi/scripts/disable_wifi.el   
elif [ "$currenttime" \< "06:45" ] && ([ "Sat" = "$currentdayoftheweek" ] || [ "Sun" = "$currentdayoftheweek" ]); then
    /usr/bin/emacs24-x -Q -l /home/pi/scripts/disable_wifi.el	
else
    /usr/bin/emacs24-x -Q -l /home/pi/scripts/enable_wifi.el	
fi


## every minute check to see if current datetime falls on scheduled target, and if so turn on or off wifi
while :; do
    sleep 60
    currenttime=$(date +%H:%M)
    currentdayoftheweek=$(date +%a)
    case $currenttime in
	21:00)
	    case $currentdayoftheweek in		
		Sun|Mon|Tue|Wed|Thu)
		    /usr/bin/emacs24-x -Q -l /home/pi/scripts/disable_wifi.el ;;		
	    esac ;;
	00:00)   # midnight
	    case $currentdayoftheweek in
		Sat|Sun|Mon)
		    /usr/bin/emacs24-x -Q -l /home/pi/scripts/disable_wifi.el ;;		
	    esac ;;
	14:30)
	    case $currentdayoftheweek in
		Mon|Tue|Wed|Thu|Fri)
		    /usr/bin/emacs24-x -Q -l /home/pi/scripts/enable_wifi.el ;;
	    esac ;;
	06:45)
	    case $currentdayoftheweek in
		Sat|Sun)
		    /usr/bin/emacs24-x -Q -l /home/pi/scripts/enable_wifi.el ;;
	    esac ;;
    esac
#	test "$?" -gt 128 && break
done 
exit 0
