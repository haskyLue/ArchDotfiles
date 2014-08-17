#!/bin/bash
#
#   -rwx- /etc/laptop-mode/batt-stop/vicious.sh
#
# Script for laptop-mode start-stop-programs module

xuser="hasky"
xauth="/home/$xuser/.Xauthority"
xdisp=":0.0"


vicious_start() {
    /bin/su - $xuser -c "/bin/echo 'vicious.activate()' | XAUTHORITY=$xauth DISPLAY=$xdisp /usr/bin/awesome-client"
    /bin/echo "Activated Vicious widgets for Awesome window manager."
}

vicious_stop() {
    /bin/su - $xuser -c "/bin/echo 'vicious.suspend()' | XAUTHORITY=$xauth DISPLAY=$xdisp /usr/bin/awesome-client"
    # # Some widgets are important while running on battery, BAT widget in particular
    # /bin/su - $xuser -c "/bin/echo 'vicious.activate(batwidget)' | XAUTHORITY=$xauth DISPLAY=$xdisp /usr/bin/awesome-client"
    /bin/echo "Suspended Vicious widgets for Awesome window manager."
}


case "$1" in
  'start')
      vicious_start
      ;;
  'stop')
      vicious_stop
      ;;
*)
      echo "usage $0 start|stop"
esac
