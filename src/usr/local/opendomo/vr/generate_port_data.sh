#!/bin/bash
#Configure files with actual port information
#This is the base script that will be used to prepare in every execution the data to identify the ports configured in every
#installation 
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
	fi	
done < tmp.txt
echo " Zonas de clima:"
cat /etc/opendomo/speech/clima.conf
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
	fi	
done < tmp.txt
echo " Sensores disponibles:"
cat /etc/opendomo/speech/sensors.conf
