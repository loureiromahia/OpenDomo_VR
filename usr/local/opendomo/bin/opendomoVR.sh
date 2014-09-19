#!/bin/bash
#Generate the data for managing ports. Retrieves the actual port data to collect,  light data, clima, sensors, analog ports.
#Data is retrieved from  /etc/opendomo/control

NAME=opendomoVR.sh
PIDFILE=/var/opendomo/run/$NAME.pid

if [ -f /etc/opendomo/speech/SETUPDONE ]
then
	echo "SET UP DONE, Voice Recognition can go on"
else
	echo "SETTING UP ENVIRONMENT, with default voice character from Antonio (spanish) /Arthur (english)"
	read IDIOMA < /etc/opendomo/lang
	if [ "$IDIOMA" == "es" ]
	then
		/usr/local/opendomo/services/config/configureVoiceSystem.sh opendomo.es
	else
		/usr/local/opendomo/services/config/configureVoiceSystem.sh opendomo.en
	fi
fi

while test -f $PIDFILE
do
	/usr/local/opendomo/bin/generate_port_data.sh
	# Start audit speech detection in background
	/usr/local/opendomo/bin/audit_speech_detect.sh &
	#Setup path:
	cd /usr/local/opendomo/run/
	echo "identification" > MODE
	echo "no" > MENU  
	# File: identification.dic, contains only 1 plugin: OpenDomo_start
	echo "NOK" > RESULTADO
	read resultado < RESULTADO
	echo $resultado
	while [ $resultado != "OK" ]           
	do     
		#Loop forever, till "Hola, OpenDomo" command is sent      
		/usr/local/opendomo/bin/autodetect.sh 
		read resultado < RESULTADO         
	done 
	echo "main" > MODE	#Normal Operation..All posible commands are accepted

	echo "NORMAL" > ESTADO
	read estado  < ESTADO
	while [ $estado == "NORMAL" ]
	do
	# Loop forever,receiving commands, till "Adios, OpenDomo"
		echo "NOK" > RESULTADO
		read resultado < RESULTADO
		while [ $resultado != "OK" ] 
			do           
				/usr/local/opendomo/bin/autodetect.sh 
				read resultado < RESULTADO         
			done
	 
	done
done
