#!/bin/sh
#desc:Voice control
### BEGIN INIT INFO
# Provides:          OpenDomoVR
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Voice control
# Description:       This file should be used to construct scripts to be
#                    placed in /etc/init.d.
# 		     Automate start up by: update-rc.d opendomoVRd 99 
### END INIT INFO

# Author: M.Loureiro
#

# Do NOT "set -e"

# PATH should only include /usr/* if it runs after the mountnfs.sh script
PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local
DESC="OpenDomoOS Voice Recognition"
NAME=opendomoVR.sh
DAEMON=/usr/local/opendomo/bin/$NAME
#DAEMON=/usr/sbin/$NAME
#DAEMON_ARGS="--options args",, No arguments
PIDFILE=/var/opendomo/run/$NAME.pid
SCRIPTNAME=/usr/local/opendomo/daemons/voiceSystem.sh

# Exit if the package is not installed
#[ -x "$DAEMON" ] || exit 0

# Read configuration variable file if it is present
#[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.2-14) to ensure that this file is present
# and status_of_proc is working.
. /lib/lsb/init-functions

#
# Function that starts the daemon/service
#
do_start()
{
	echo "Running" > $PIDFILE
	$DAEMON & 
}

#
# Function that stops the daemon/service
#
do_stop()
{
	rm -f $PIDFILE
}

#
# Function that sends a SIGHUP to the daemon/service
#
do_reload() {
	do_stop
	do_start
}

case "$1" in
  start)
	log_daemon_msg "Starting $DESC" "$NAME"
	do_start
	log_end_msg 0
	;;
  stop)
	log_daemon_msg "Stopping $DESC" "$NAME"
	do_stop
	log_end_msg 0 
	;;
  status)	
	test -f $PIDFILE && exit 0 || exit $?
	;;
  reload|force-reload|restart|force-reload)
	do_reload
	;;
  *)
	echo "Usage: $SCRIPTNAME {start|stop|status|restart|force-reload}" 
	exit 3
	;;
esac

:
