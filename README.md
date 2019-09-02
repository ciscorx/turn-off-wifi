# turn-off-wifi
My sister asked me to schedule her at&t u-verse routers wifi so that it would turn off during the night and on during the day in order that her son wouldnt be using it late at night.  Its sad that the router doesnt already come with such a feature.

This script runs in linux and requires the latest emacs-w3m and has so far been tested on ubuntu and tinker board os.
Also required is pp.el, the pretty print function from https://github.com/typester/emacs/blob/master/lisp/emacs-lisp/pp.el

The script is scheduled using cron with the following crontab:
    0 22 * * mon,tue,wed,thu,fri disable_wifi.sh
    30 14 * * mon,tue,wed,thu,fri enable_wifi.sh
    0 0 * * sat,sun disable_wifi.sh
    0 8 * * sat,sun enable_wifi.sh
 