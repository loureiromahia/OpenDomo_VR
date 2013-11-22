#!/bin/bash
# logica_opendomo.sh
# chkconfig: 345 20 80
# description: Allows to start/stop/restart the OpenDomo Voice Recognition logic at startup
# processname: logica_opendomo.sh
DAEMON_PATH="~/OpenDomo_VR/logica_opendomo.sh"
	 
DAEMON=logica_opendomo.sh
DAEMONOPTS="-my opts"
	 
NAME=myapp
DESC="My daemon description"
PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME
	 
case "$1" in
start)
	printf "%-50s" "Starting $NAME..."
	cd $DAEMON_PATH
        PID=`$DAEMON $DAEMONOPTS > /dev/null 2>&1 & echo $!`
#echo "Saving PID" $PID " to " $PIDFILE
      	if [ -z $PID ]; then
		printf "%s\n" "Fail"
	else
		echo $PID > $PIDFILE
		printf "%s\n" "Ok"
        fi
	;;
status)
       printf "%-50s" "Checking $NAME..."
       if [ -f $PIDFILE ]; then
       		PID=`cat $PIDFILE`
       		if [ -z "`ps axf | grep ${PID} | grep -v grep`" ]; then
	     		printf "%s\n" "Process dead but pidfile exists"
       		else
                	echo "Running"
       		fi
	else
	        printf "%s\n" "Service not running"
        fi
	;;
stop)
        printf "%-50s" "Stopping $NAME"
        PID=`cat $PIDFILE`
        cd $DAEMON_PATH
        if [ -f $PIDFILE ]; then
	        kill -HUP $PID
	        printf "%s\n" "Ok"
           	rm -f $PIDFILE
        else
 	        printf "%s\n" "pidfile not found"
	fi
	;;
	 
restart)
	$0 stop
	$0 start
	;;
	 
*)
        echo "Usage: $0 {status|start|stop|restart}"
        exit 1
esac


### BEGIN INIT INFO
# Provides:          Automatic Voice Recognition fo Open Domo
# Required-Start:    $syslog
# Required-Stop:     $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Automatic Voice Recognition fo Open Domo
# Description:
#
### END INIT INFO
echo "Setting up customized environment..."
 start() {
   ~/OpenDomo_VR/logica_opendomo.sh
   }

   stop() {
     # code to stop app comes here 
   }

   case "$1" in 
    start)
        start
        ;;
    stop)
        stop
        ;;
    retart)
        stop
        start
        ;;
    *)
         echo "Usage: $0 {start|stop|restart}"
   esac

   exit 0
 

