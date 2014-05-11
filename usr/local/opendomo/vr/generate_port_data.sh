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
#generate CONFIG file, containing the options of config menu
if  [ -f /etc/opendomo/speech/CONFIG ]
then	
	rm /etc/opendomo/speech/CONFIG
fi
touch /etc/opendomo/speech/CONFIG
cd /usr/local/opendomo/services/config/
grep '#desc' * | grep -n "#desc" | sed 's/#desc://' >> /etc/opendomo/speech/CONFIG
#generate menu view options: themes available, skins available and lanfiles availables
if  [ -f /etc/opendomo/speech/INTERFACE ]
then	
	rm /etc/opendomo/speech/INTERFACE
fi
touch /etc/opendomo/speech/INTERFACE
echo "Visual interface configuration." > /etc/opendomo/speech/INTERFACE
cd /var/www/themes
ls -l| grep drwxr |awk '{ print $9}' > tmp.txt
i=0
echo  "Theme configuration " >> /etc/opendomo/speech/INTERFACE
while read line
do	
	((i++))		
	echo -n "For theme " >> /etc/opendomo/speech/INTERFACE	
	stri=`echo $line`
	echo -n $stri >>  /etc/opendomo/speech/INTERFACE
	echo -n " ,say, interface theme " >> /etc/opendomo/speech/INTERFACE
	echo  $i "." >> /etc/opendomo/speech/INTERFACE
done < tmp.txt

cd /var/www/skins
ls -l| grep drwxr |awk '{ print $9}' > tmp.txt
i=0
echo  "Skin configuration " >> /etc/opendomo/speech/INTERFACE
while read line
do	
	((i++))		
	echo -n "For skin  " >> /etc/opendomo/speech/INTERFACE	
	stri=`echo $line`
	echo -n $stri >>  /etc/opendomo/speech/INTERFACE
	echo -n " ,say,  interface skin " >> /etc/opendomo/speech/INTERFACE
	echo  $i "." >> /etc/opendomo/speech/INTERFACE
done < tmp.txt
rm tmp.txt

cd /etc/opendomo/langfiles
cat available | sed 's/Català/Catalan/g' | sed 's/,/ ./g' | sed 's/..:/Language configuration. Say, interface language 1, for /' |sed 's/..:/ Say interface language 2, for /' |sed 's/..:/ Say interface language 3, for /' |sed 's/..:/ Say interface language 4, for /' |sed 's/..:/ Say interface language 5, for /' |sed 's/..:/ Say interface language 6, for /'|sed 's/..:/ Say interface language 7, for /' |sed 's/ Say/\n&/g'    >> /etc/opendomo/speech/INTERFACE
echo >> /etc/opendomo/speech/INTERFACE
echo "To save interface configuration, say, interface save" >> /etc/opendomo/speech/INTERFACE

grep '#desc' * | grep -n "#desc" | sed 's/#desc://' >> /etc/opendomo/speech/CONFIG
cd /usr/local/opendomo/vr
#generate configmenu.txt file, containing the voice stream, with the options
if  [ -f /etc/opendomo/speech/configmenu.txt ]
then	
	rm /etc/opendomo/speech/configmenu.txt
fi
touch /etc/opendomo/speech/configmenu.txt
echo "Configuration Menu " > /etc/opendomo/speech/configmenu.txt
while read line
do	
	echo -n " For " >> /etc/opendomo/speech/configmenu.txt	
	stri=`echo $line | cut -d ":" -f3 -`
	echo -n $stri >>  /etc/opendomo/speech/configmenu.txt
	echo -n " , say " >> /etc/opendomo/speech/configmenu.txt
	echo $line | cut -d ":" -f1 - >> /etc/opendomo/speech/configmenu.txt
done < /etc/opendomo/speech/CONFIG
#generate actual network configuration data
if  [ -f /etc/opendomo/speech/netmenu.txt ]
then	
	rm /etc/opendomo/speech/netmenu.txt
fi
touch /etc/opendomo/speech/netmenu.txt
echo "Network configuration " > /etc/opendomo/speech/netmenu.txt
echo "Actual values " > /etc/opendomo/speech/netmenu.txt
/usr/local/opendomo/services/config/configLocalNetwork.sh > tmp.txt
MODE=`cat tmp.txt |grep mode | awk '{ print $5}'`
IP=`cat tmp.txt |grep ip | awk '{ print $4}'`
MASK=`cat tmp.txt |grep mask | awk '{ print $4}'`
GW=`cat tmp.txt |grep gw | awk '{ print $4}'`
DNS=`cat tmp.txt |grep dns | awk '{ print $5}'`
echo " mode " $MODE >> /etc/opendomo/speech/netmenu.txt
echo " IP " $IP >> /etc/opendomo/speech/netmenu.txt
echo " mask " $MASK >> /etc/opendomo/speech/netmenu.txt
echo " gateway " $GW >> /etc/opendomo/speech/netmenu.txt
echo " DNS " $DNS >> /etc/opendomo/speech/netmenu.txt
rm tmp.txt

#generate actual control device data
# -available control cards
# -available ports
if  [ -f /etc/opendomo/speech/portmenu.txt ]
then	
	rm /etc/opendomo/speech/portmenu.txt
fi
touch /etc/opendomo/speech/portmenu.txt
PS=""
PORTS="/dev/dummy"
#Cards available
echo "Card:dummy:1" > /etc/opendomo/speech/portmenu.txt
i=1

if test -e /usr/bin/micropik
then
	((i++))
	echo "Card:micropik:"$i >> /etc/opendomo/speech/portmenu.txt 
	PS="`ls /dev/ttyS* 2>/dev/null | cut -c1-15` "      	
fi
if test -e /usr/bin/arduino
then
	((i++))
	echo "Card:arduino:"$i >> /etc/opendomo/speech/portmenu.txt
	PS="$PS `ls /dev/ttyU* 2>/dev/null | cut -c1-15`"        	
fi
if test -e /usr/bin/x10
then
	((i++))
	echo "Card:x10:"$i >> /etc/opendomo/speech/portmenu.txt 
	PS="$PS `/usr/bin/x10 -l 2>/dev/null`"       	
fi
if test -e /usr/bin/domino
then
	((i++))
	echo "Card:domino:"$i >> /etc/opendomo/speech/portmenu.txt       	
fi
#Ports...if no new port, at least /dev/dummy
i=1
echo "Port:/dev/dummy:"$i >> /etc/opendomo/speech/portmenu.txt  
for p in $PS; do
        ((i++))
	echo "Port:"$p":"$i >> /etc/opendomo/speech/portmenu.txt  
done

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
		echo -n "switch ON light " >> /etc/opendomo/speech/AYUDA		
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/AYUDA
		echo -n "switch OFF light " >> /etc/opendomo/speech/AYUDA		
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
		echo -n "switch ON climate " >> /etc/opendomo/speech/AYUDA		
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/AYUDA
		echo -n "switch OFF climate " >> /etc/opendomo/speech/AYUDA		
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
		echo -n "Activate video " >> /etc/opendomo/speech/AYUDA		
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/AYUDA
		echo -n "Deactivate video " >> /etc/opendomo/speech/AYUDA		
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
		echo -n "Activate music " >> /etc/opendomo/speech/AYUDA		
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/AYUDA
		echo -n "Deactivate music " >> /etc/opendomo/speech/AYUDA		
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
		echo -n "Inform about " >> /etc/opendomo/speech/AYUDA		
		echo $stri >> /etc/opendomo/speech/AYUDA
	
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
			echo -n "Change temperature " >> /etc/opendomo/speech/AYUDA		
			stri=`cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g`
			echo -n $stri >> /etc/opendomo/speech/AYUDA			
			echo " value, degrees" >> /etc/opendomo/speech/AYUDA		
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
			echo -n "Change Light " >> /etc/opendomo/speech/AYUDA		
			stri=`cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g`
			echo -n $stri >> /etc/opendomo/speech/AYUDA
			echo " value, percentage" >> /etc/opendomo/speech/AYUDA		
		fi
	fi
done < tmp.txt
echo " Zonas con reguladores de temperatura:"
cat /etc/opendomo/speech/varclimate.conf
#Generate AYUDA 		
echo "Bye OpenDomo " >> /etc/opendomo/speech/AYUDA		
			
