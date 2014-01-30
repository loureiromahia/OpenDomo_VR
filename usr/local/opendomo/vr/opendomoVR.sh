#!/bin/bash
#Generate the data for managing ports. Retrieves the actual port data to collect,  light data, clima, sensors, analog ports.
#Data is retrieved from  /etc/opendomo/control
if [ -f /etc/opendomo/speech/SETUPDONE ]
then
	echo "SET UP DONE,, Voice Recognition can go on"
else
	echo "SETTING UP ENVIRONMENT, with default voice character from Antonio (spanish) /Arthur (english)"
	read IDIOMA < /etc/opendomo/lang
	if [ "$IDIOMA" == "es" ]
	then
		/usr/local/opendomo/services/config/configureVoiceSystem.sh antonio.es
	else
		/usr/local/opendomo/services/config/configureVoiceSystem.sh arthur.en
	fi
fi
/usr/local/opendomo/vr/generate_port_data.sh
#Setup path:
cd /usr/local/opendomo/vr
echo "identification" > MODE  
# File: identification.dic, contains only 1 plugin: OpenDomo_start
echo "NOK" > RESULTADO
read resultado < RESULTADO
echo $resultado
while [ $resultado != "OK" ]           
	do     
		#Loop forever, till "Hola, OpenDomo" command is sent      
		./autodetect.sh 
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
				./autodetect.sh 
				read resultado < RESULTADO         
			done
	 
	done

