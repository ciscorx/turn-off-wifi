# turn-off-wifi
Here's a script which, when executed from a computer connect to the local LAN network, logs into the at&t u-verse router via its web interface to disable or enable its wifi. 

My sister asked me to schedule her at&t u-verse router's wifi so that it would turn off during the night and on during the day in order that her son wouldn't be using it late at night.  It's sad that the router doesn't already come with such a feature.



## Requirements
This script runs in linux and requires w3m and emacs, of a version number of probably at least 23.3.1 and the latest emacs-w3m package.
Also required is pp.el, the pretty print function from https://github.com/typester/emacs/blob/master/lisp/emacs-lisp/pp.el

It has so far been tested on ubuntu 12.04, on 20181023-tinker-board-linaro-stretch-alip-v2.0.8.img on asus tinker board and 2018-11-13-raspbian-stretch on raspberry pi 3. 

It fails to run on debian buster, due to its SSL, complaining that "EE certificate key too weak".  Also, it fails to work on MS Windows due to the lack of w3m.

## Scheduling
The script is scheduled using cron with the following crontab:<br/>
    0 22 * * sun,mon,tue,wed,thu turn-off-wifi.sh<br/>
    30 14 * * mon,tue,wed,thu,fri turn-on-wifi.sh<br/>
    0 0 * * fri,sat turn-off-wifi.sh<br/>
    0 8 * * sat,sun turn-on-wifi.sh<br/>
 