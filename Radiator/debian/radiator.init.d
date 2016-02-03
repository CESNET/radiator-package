#!/bin/sh
# Start/stop the Radiator daemon. Script by Jan Tomasek <jan@tomasek.cz>

### BEGIN INIT INFO
# Provides:          radiator
# Required-Start:    $remote_fs $syslog $network
# Required-Stop:     $remote_fs $syslog $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start radiusd daemon at boot time
# Description:       Enable service provided by radiusd.
### END INIT INFO

set -u

. /lib/lsb/init-functions

prog="radiator"
program="/usr/bin/radiusd"
cfg=/etc/radiator/radius.cfg
descr="Radiator daemon"

test -f $program || exit 0

case "$1" in
start)
    echo -n "Starting $descr: "
    if [ ! -f $cfg ]
    then
	echo "missing $cfg failed!";
	exit 0;
    fi
    /sbin/start-stop-daemon --start --quiet --exec $program >/dev/null 2>&1
    if [ $? = 0 ]; then
	    echo "$prog."
    else
	    echo "failed!"
	exit 1
    fi
;;

stop)
    echo -n "Stopping $descr: "
    ps aux |grep "/usr/bin/perl $program"| grep -v grep| sed "s/  */ /g"| cut -d " " -f 2 | while read PID; do kill $PID; done;
    echo "$prog."
;;

restart|force-reload)
    echo "Restarting $descr."
    $0 stop
    $0 start
;;

*)
    echo "Usage: $0 start|stop|restart"
    exit 1 
;;
esac
exit 0
