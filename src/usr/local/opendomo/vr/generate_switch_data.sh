#!/bin/bash
#Configure files where switches for light or clima exist. Only these zones can be switched ON/OFF
# Lights
grep -ir "light" /etc/opendomo/control/* | cut -d ":" -f1 - > tmp.txt
if  [ -f /etc/opendomo/speech/light.conf ]
then	
	rm /etc/opendomo/speech/light.conf
fi
touch /etc/opendomo/speech/light.conf
while read line
do	
	#the switch, as seen in the tree /etc/opendomo/control, that will be similar ij /var/opendomo/control...i guess	
	echo -n $line | sed -e "s/\/etc\/opendomo\/control//"g >> /etc/opendomo/speech/light.conf 
	echo -n ":" >> /etc/opendomo/speech/light.conf
	#the name...
	cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g | sed s/"\/n"/""/g >> /etc/opendomo/speech/light.conf
done < tmp.txt
echo " Zonas de luz:"
cat /etc/opendomo/speech/light.conf
#Clima
grep -ir "clima" /etc/opendomo/control/* | cut -d ":" -f1 - > tmp.txt
if [ -f /etc/opendomo/speech/clima.conf ]
then
	rm /etc/opendomo/speech/clima.conf
fi

touch /etc/opendomo/speech/clima.conf
while read line
do	
	#the switch, as seen in the tree /etc/opendomo/control, that will be similar ij /var/opendomo/control...i guess	
	echo -n $line | sed -e "s/\/etc\/opendomo\/control//"g >> /etc/opendomo/speech/clima.conf 
	echo -n ":" >> /etc/opendomo/speech/clima.conf	
	#the name...	
	cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/clima.conf
	

done < tmp.txt
echo " Zonas de clima:"
cat /etc/opendomo/speech/clima.conf
