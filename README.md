# turn-off-wifi
Here's a script which, when executed from a computer that is connected to the local LAN network, logs into the at&t u-verse router via its web interface to disable or enable its wifi. 

My sister asked me to schedule her at&t u-verse router's wifi so that it would turn off during the night and on during the day in order that her son wouldn't be using it late at night.  It's sad that the router doesn't already come with such a feature.



## Requirements
This script runs in linux and requires w3m and emacs, of a version number of probably at least 23.3.1 and the latest emacs-w3m package.
Also required is pp.el, the pretty print function from https://github.com/typester/emacs/blob/master/lisp/emacs-lisp/pp.el

It has so far been tested on ubuntu 12.04, on 20181023-tinker-board-linaro-stretch-alip-v2.0.8.img on asus tinker board and 2018-11-13-raspbian-stretch on raspberry pi 3. 

It fails to run on debian buster, due to its SSL, complaining that "EE certificate key too weak".  Also, it fails to work on MS Windows due to the lack of w3m.

## Scheduling
Raspberry pi 3 simply wouldnt run this script using cron, nor from rc.local nor init.d.  At the end of the day I resorted to running a server process, wifi_scheduler.sh, at startup from lxsession/LXDE-pi/autostart.  Correction: it actually does work from cron if called through the screen command.   For example, 0 9 * * mon,tue,wed screen -dm emacs -nw -Q -l enable_wifi.el

To set up the server on raspberry pi 3:
* Make a directory with the command mkdir -p ~/.config/lxsession/LXDE-pi/<br/>
* Copy the /etc/xdg/lxsession/LXDE/autostart to ~/.config/lxsession/LXDE-pi/autostart<br/>
* Move the file wifi_scheduler.sh to /usr/bin so it can be seen.<br/>
* Make a directory called /home/pi/scripts and put disable_wifi.el and enable_wifi.el in that directory
* Edit ~/.config/lxsession/LXDE-pi/autostart with the following (or just use the autostart file I provided):<br/>
@lxpanel --profile LXDE-pi<br/>
@pcmanfm --desktop --profile LXDE-pi<br/>
#@xscreensaver -no-splash<br/>
point-rpi<br/>
@wifi_scheduler.sh<br/>




