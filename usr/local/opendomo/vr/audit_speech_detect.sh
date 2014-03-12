#!/bin/bash
vrlife=true

while [ $vrlife = true ]
do
	#audit every 30 sec
	sleep 30
	
	if [ `ps -eaf | grep -c "recording.flac"` -lt 2 ] && [ `ps -eaf | grep -c "autodetect"` -eq 2 ] 
	then
		p1=`ps -ea |grep autodetect| awk '{ print $1}'`
		date >> /usr/local/opendomo/vr/AUDIT
		kill $p1
	fi
	
	if [ `ps -eaf | grep -c "opendomoVR"` -lt 2 ]
	then
		vrlife=false
	fi
done
