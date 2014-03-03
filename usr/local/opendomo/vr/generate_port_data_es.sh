#!/bin/bash
#Configure files with actual port information
#This is the base script that will be used to prepare in every execution the data to identify the ports configured in every
#installation 
# First, generate AYUDA file, with all the posible commands
if  [ -f /etc/opendomo/speech/AYUDA ]
then	
	rm /etc/opendomo/speech/AYUDA
fi
touch /etc/opendomo/speech/AYUDA
# Lights:
grep -ir "light" /etc/opendomo/control/* | cut -d ":" -f1 - > tmp.txt
if  [ -f /etc/opendomo/speech/light.conf ]
then	
	rm /etc/opendomo/speech/light.conf
fi
touch /etc/opendomo/speech/light.conf
while read line
do	
	# only ports with way =out
	if [ `cat $line | grep -c "out"` -gt 0 ]
	then
		#the switch, as seen in the tree /etc/opendomo/control, 
		#that will be similar in /var/opendomo/control...i guess	
		echo -n $line | sed -e "s/\/etc\/opendomo\/control//"g >> /etc/opendomo/speech/light.conf 
		echo -n ":" >> /etc/opendomo/speech/light.conf
		#the name...
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/light.conf
		#Generate AYUDA
		echo "Encender luz" >> /etc/opendomo/speech/AYUDA		
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/AYUDA
		echo "Apagar luz" >> /etc/opendomo/speech/AYUDA		
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/AYUDA
	fi
done < tmp.txt
echo " Zonas de luz:"
cat /etc/opendomo/speech/light.conf
#Clima:
grep -ir "climate" /etc/opendomo/control/* | cut -d ":" -f1 - > tmp.txt
if [ -f /etc/opendomo/speech/clima.conf ]
then
	rm /etc/opendomo/speech/clima.conf
fi

touch /etc/opendomo/speech/clima.conf
while read line
do	
	# only ports with way =out
	if [ `cat $line | grep -c "out"` -gt 0 ]
	then	
		#the switch, as seen in the tree /etc/opendomo/control, 
		#that will be similar in /var/opendomo/control...i guess	
		echo -n $line | sed -e "s/\/etc\/opendomo\/control//"g >> /etc/opendomo/speech/clima.conf 
		echo -n ":" >> /etc/opendomo/speech/clima.conf	
		#the name...	
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/clima.conf
		#Generate AYUDA		
		echo "Encender clima" >> /etc/opendomo/speech/AYUDA		
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/AYUDA
		echo "Apagar clima" >> /etc/opendomo/speech/AYUDA		
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/AYUDA
	fi	
done < tmp.txt
echo " Zonas de clima:"
cat /etc/opendomo/speech/clima.conf

#Video:
grep -ir "video" /etc/opendomo/control/* | cut -d ":" -f1 - > tmp.txt
if [ -f /etc/opendomo/speech/video.conf ]
then
	rm /etc/opendomo/speech/video.conf
fi

touch /etc/opendomo/speech/video.conf
while read line
do	
	# only ports with way =out
	if [ `cat $line | grep -c "out"` -gt 0 ]
	then	
		#the switch, as seen in the tree /etc/opendomo/control, 
		#that will be similar in /var/opendomo/control...i guess	
		echo -n $line | sed -e "s/\/etc\/opendomo\/control//"g >> /etc/opendomo/speech/video.conf 
		echo -n ":" >> /etc/opendomo/speech/video.conf	
		#the name...	
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/video.conf
		#Generate AYUDA 		
		echo "Activar video" >> /etc/opendomo/speech/AYUDA		
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/AYUDA
		echo "Desactivar video" >> /etc/opendomo/speech/AYUDA		
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/AYUDA
		
	fi	
done < tmp.txt
echo " Zonas de video:"
cat /etc/opendomo/speech/video.conf

#Music:
grep -ir "music" /etc/opendomo/control/* | cut -d ":" -f1 - > tmp.txt
if [ -f /etc/opendomo/speech/music.conf ]
then
	rm /etc/opendomo/speech/music.conf
fi

touch /etc/opendomo/speech/music.conf
while read line
do	
	# only ports with way =out
	if [ `cat $line | grep -c "out"` -gt 0 ]
	then	
		#the switch, as seen in the tree /etc/opendomo/control, 
		#that will be similar in /var/opendomo/control...i guess	
		echo -n $line | sed -e "s/\/etc\/opendomo\/control//"g >> /etc/opendomo/speech/music.conf 
		echo -n ":" >> /etc/opendomo/speech/music.conf	
		#the name...	
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/music.conf
		#Generate AYUDA 		
		echo "Activar musica" >> /etc/opendomo/speech/AYUDA		
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/AYUDA
		echo "Desactivar musica" >> /etc/opendomo/speech/AYUDA		
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/AYUDA
	fi	
done < tmp.txt
echo " Zonas de musica:"
cat /etc/opendomo/speech/music.conf


#Input ports: sensors
grep -ir "way=in" /etc/opendomo/control/* | cut -d ":" -f1 - > tmp.txt
grep -ir "way='in'" /etc/opendomo/control/* | cut -d ":" -f1 - >> tmp.txt
if [ -f /etc/opendomo/speech/sensors.conf ]
then
	rm /etc/opendomo/speech/sensors.conf
fi
touch /etc/opendomo/speech/sensors.conf
while read line
do	
	# only ports really used...with tag assigned....maybe, later we have to prepare a different filter...
	if [ `cat $line | grep -c "tag"` -gt 0 ]
	then		
		#the sensor, as seen in the tree /etc/opendomo/control, 
		#that will be similar in /var/opendomo/control...i guess	
		echo -n $line | sed -e "s/\/etc\/opendomo\/control//"g >> /etc/opendomo/speech/sensors.conf 
		echo -n ":" >> /etc/opendomo/speech/sensors.conf	
		#the name...	
		stri=`cat $line | grep desc | cut -d "=" -f2 - | sed s/"'"/""/g` 
		echo -n $stri >> /etc/opendomo/speech/sensors.conf
		echo -n ":" >> /etc/opendomo/speech/sensors.conf
		#the units...
		# when blank in units, it means a digital sensor (ON/OFF)	
		cat  $line | grep units | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/sensors.conf
		#Generate AYUDA 		
		echo "Informar de" >> /etc/opendomo/speech/AYUDA		
		echo -n $stri >> /etc/opendomo/speech/AYUDA
	
	fi	
done < tmp.txt
echo " Sensores disponibles:"
cat /etc/opendomo/speech/sensors.conf
# Variable Lights:
grep -ir "light" /etc/opendomo/control/* | cut -d ":" -f1 - > tmp.txt
if  [ -f /etc/opendomo/speech/varlight.conf ]
then	
	rm /etc/opendomo/speech/varlight.conf
fi
touch /etc/opendomo/speech/varlight.conf
while read line
do	
	# only ports with way =out
	if [ `cat $line | grep -c "out"` -gt 0 ]
	then
		if [ `cat $line | grep -c "analog"` -gt 0 ]
		then
			#the switch, as seen in the tree /etc/opendomo/control, 
			#that will be similar in /var/opendomo/control...i guess	
			echo -n $line | sed -e "s/\/etc\/opendomo\/control//"g >> /etc/opendomo/speech/varlight.conf 
			echo -n ":" >> /etc/opendomo/speech/varlight.conf
			#the name...
			cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/varlight.conf
			#Generate AYUDA 		
			echo "Ajustar termostato " >> /etc/opendomo/speech/AYUDA		
			cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/AYUDA
			echo "valor en grados" >> /etc/opendomo/speech/AYUDA		
		fi
	fi
done < tmp.txt
echo " Zonas con reguladores de luz:"
cat /etc/opendomo/speech/varlight.conf
# Variable Climate:
grep -ir "climate" /etc/opendomo/control/* | cut -d ":" -f1 - > tmp.txt
if  [ -f /etc/opendomo/speech/varclimate.conf ]
then	
	rm /etc/opendomo/speech/varclimate.conf
fi
touch /etc/opendomo/speech/varclimate.conf
while read line
do	
	# only ports with way =out
	if [ `cat $line | grep -c "out"` -gt 0 ]
	then
		if [ `cat $line | grep -c "analog"` -gt 0 ]
		then
			#the switch, as seen in the tree /etc/opendomo/control, 
			#that will be similar in /var/opendomo/control...i guess	
			echo -n $line | sed -e "s/\/etc\/opendomo\/control//"g >> /etc/opendomo/speech/varclimate.conf 
			echo -n ":" >> /etc/opendomo/speech/varclimate.conf
			#the name...
			cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/varclimate.conf
			#Generate AYUDA 		
			echo "Ajustar luz " >> /etc/opendomo/speech/AYUDA		
			cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/AYUDA
			echo "valor en porcentaje" >> /etc/opendomo/speech/AYUDA		
		fi
	fi
done < tmp.txt
echo " Zonas con reguladores de temperatura:"
cat /etc/opendomo/speech/varclimate.conf
#Generate AYUDA 		
echo "Adios OpenDomo " >> /etc/opendomo/speech/AYUDA		
			
