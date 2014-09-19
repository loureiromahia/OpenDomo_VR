#!/bin/bash
vrlife=true

while [ $vrlife = true ]
do
	#audit every 60 sec
	sleep 60
	
	if [ `ps -eaf | grep -c "recording.flac"` -lt 2 ] && [ `ps -eaf | grep -c "autodetect"` -ge 2 ] 
	then
		if [ `ps -eaf | grep -c "recognize"` -lt 2 ]
		then
			# If there is no process running of recognize (system is not acting, but in voice recognition
			p1=`ps -ea |grep autodetect| awk '{ print $1}'`
			date >> /var/opendomo/tmp/AUDIT
			kill $p1
		fi
	fi
	
	if [ `ps -eaf | grep -c "opendomoVR"` -lt 2 ]
	then
		#Suicide after main process is killed
		vrlife=false
	fi
done
