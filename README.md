# turn-off-wifi
My sister asked me to schedule her at&t u-verse router's wifi so that it would turn off during the night and on during the day in order that her son wouldn't be using it late at night.  It's sad that the router doesnt already come with such a feature.

## Requirements
This script runs in linux and requires emacs with a version number of probably at least 23.3.1 and the latest emacs-w3m package.
Also required is pp.el, the pretty print function from https://github.com/typester/emacs/blob/master/lisp/emacs-lisp/pp.e

It has so far been tested on ubuntu and tinker board os.

## Scheduling
The script is scheduled using cron with the following crontab:<br/>
    0 22 * * mon,tue,wed,thu,fri turn-off-wifi.sh<br/>
    30 14 * * mon,tue,wed,thu,fri turn-on-wifi.sh<br/>
    0 0 * * sat,sun turn-off-wifi.sh<br/>
    0 8 * * sat,sun turn-on-wifi.sh<br/>
 