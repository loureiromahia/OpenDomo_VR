#!/bin/bash
#Setup path:
cd /usr/local/opendomo/VR
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

