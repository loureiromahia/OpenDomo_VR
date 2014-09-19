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
echo "Configuracion visual de interface." > /etc/opendomo/speech/INTERFACE
cd /var/www/themes
ls -l| grep drwxr |awk '{ print $9}' > tmp.txt
i=0
echo  "Configuracion de tema " >> /etc/opendomo/speech/INTERFACE
while read line
do	
	((i++))		
	echo -n "Para tema " >> /etc/opendomo/speech/INTERFACE	
	stri=`echo $line`
	echo -n $stri >>  /etc/opendomo/speech/INTERFACE
	echo -n " , diga interfaz tema " >> /etc/opendomo/speech/INTERFACE
	echo  $i "." >> /etc/opendomo/speech/INTERFACE
done < tmp.txt

cd /var/www/skins
ls -l| grep drwxr |awk '{ print $9}' > tmp.txt
i=0
echo  "Configuracion de piel " >> /etc/opendomo/speech/INTERFACE
while read line
do	
	((i++))		
	echo -n "Para piel " >> /etc/opendomo/speech/INTERFACE	
	stri=`echo $line`
	echo -n $stri >>  /etc/opendomo/speech/INTERFACE
	echo -n " , diga interfaz piel " >> /etc/opendomo/speech/INTERFACE
	echo  $i "." >> /etc/opendomo/speech/INTERFACE
done < tmp.txt
rm tmp.txt

cd /etc/opendomo/langfiles
cat available | sed 's/Català/Catalan/g' | sed 's/,/ ./g' | sed 's/..:/Configuracion de idioma. Diga interfaz idioma 1, para /' |sed 's/..:/ Diga interfaz idioma 2, para /' |sed 's/..:/ Diga interfaz idioma 3, para /' |sed 's/..:/ Diga interfaz idioma 4, para /' |sed 's/..:/ Diga interfaz idioma 5, para /' |sed 's/..:/ Diga interfaz idioma 6, para /'|sed 's/..:/ Diga interfaz idioma 7: para /' |sed 's/ Diga/\n&/g'    >> /etc/opendomo/speech/INTERFACE
echo >> /etc/opendomo/speech/INTERFACE
echo "Para salvar configuracion interfaz, diga interfaz salvar" >> /etc/opendomo/speech/INTERFACE

grep '#desc' * | grep -n "#desc" | sed 's/#desc://' >> /etc/opendomo/speech/CONFIG
cd /usr/local/opendomo/vr
#generate configmenu.txt file, containing the voice stream, with the options
if  [ -f /etc/opendomo/speech/configmenu.txt ]
then	
	rm /etc/opendomo/speech/configmenu.txt
fi
touch /etc/opendomo/speech/configmenu.txt
echo "Menu configuracion " > /etc/opendomo/speech/configmenu.txt
while read line
do	
	echo -n " Para " >> /etc/opendomo/speech/configmenu.txt	
	stri=`echo $line | cut -d ":" -f3 -`
	echo -n $stri >>  /etc/opendomo/speech/configmenu.txt
	echo -n " , diga " >> /etc/opendomo/speech/configmenu.txt
	echo $line | cut -d ":" -f1 - >> /etc/opendomo/speech/configmenu.txt
done < /etc/opendomo/speech/CONFIG
#generate actual network configuration data
if  [ -f /etc/opendomo/speech/netmenu.txt ]
then	
	rm /etc/opendomo/speech/netmenu.txt
fi
touch /etc/opendomo/speech/netmenu.txt
echo "Configuracion de red " > /etc/opendomo/speech/netmenu.txt
echo "Valores actuales " > /etc/opendomo/speech/netmenu.txt
/usr/local/opendomo/services/config/configLocalNetwork.sh > tmp.txt
MODE=`cat tmp.txt |grep mode | awk '{ print $5}'`
IP=`cat tmp.txt |grep ip | awk '{ print $4}'`
MASK=`cat tmp.txt |grep mask | awk '{ print $4}'`
GW=`cat tmp.txt |grep gw | awk '{ print $4}'`
DNS=`cat tmp.txt |grep dns | awk '{ print $5}'`
echo " modo " $MODE >> /etc/opendomo/speech/netmenu.txt
echo " IP " $IP >> /etc/opendomo/speech/netmenu.txt
echo " mascara " $MASK >> /etc/opendomo/speech/netmenu.txt
echo " puerta de enlace " $GW >> /etc/opendomo/speech/netmenu.txt
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
if  [ -f /etc/opendomo/speech/lightmenu.txt ]
then	
	rm /etc/opendomo/speech/lightmenu.txt
fi
touch /etc/opendomo/speech/lightmenu.txt
echo "Menu de luces. Para encender diga activar numero. Para apagar diga desactivar numero" >> /etc/opendomo/speech/lightmenu.txt
i=0
while read line
do	
	# only ports with way =out
	
	if [ `cat $line | grep -c "out"` -gt 0 ]
	then
		((i++))		
		#the switch, as seen in the tree /etc/opendomo/control, 
		#that will be similar in /var/opendomo/control...i guess	
		echo -n $line | sed -e "s/\/etc\/opendomo\/control//"g >> /etc/opendomo/speech/light.conf 
		echo -n ":" >> /etc/opendomo/speech/light.conf
		#the name...
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/light.conf
		#Generate lightmenu.txt
		stri=`cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g` 
		echo -n $stri >> /etc/opendomo/speech/lightmenu.txt
		echo -n " numero " >> /etc/opendomo/speech/lightmenu.txt
		echo $i >> /etc/opendomo/speech/lightmenu.txt
		#Generate AYUDA
		echo -n "Encender luz " >> /etc/opendomo/speech/AYUDA		
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/AYUDA
		echo -n "Apagar luz " >> /etc/opendomo/speech/AYUDA		
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
if  [ -f /etc/opendomo/speech/climamenu.txt ]
then	
	rm /etc/opendomo/speech/climamenu.txt
fi
touch /etc/opendomo/speech/climamenu.txt
echo "Menu de clima. Para encender diga activar numero. Para apagar diga desactivar numero " >> /etc/opendomo/speech/climamenu.txt
i=0
while read line
do	
	# only ports with way =out
	
	if [ `cat $line | grep -c "out"` -gt 0 ]
	then	
		((i++))		
		#the switch, as seen in the tree /etc/opendomo/control, 
		#that will be similar in /var/opendomo/control...i guess	
		echo -n $line | sed -e "s/\/etc\/opendomo\/control//"g >> /etc/opendomo/speech/clima.conf 
		echo -n ":" >> /etc/opendomo/speech/clima.conf	
		#the name...	
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/clima.conf
		#Generate climamenu.txt
		stri=`cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g` 		
		echo -n $stri >> /etc/opendomo/speech/climamenu.txt
		echo -n " numero " >> /etc/opendomo/speech/climamenu.txt
		echo $i >> /etc/opendomo/speech/climamenu.txt		
		#Generate AYUDA		
		echo -n "Encender clima " >> /etc/opendomo/speech/AYUDA		
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/AYUDA
		echo -n "Apagar clima " >> /etc/opendomo/speech/AYUDA		
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

if  [ -f /etc/opendomo/speech/videomenu.txt ]
then	
	rm /etc/opendomo/speech/videomenu.txt
fi
touch /etc/opendomo/speech/videomenu.txt
echo "Menu de video. Para activar, diga activar numero. Para desactivar diga desactivar numero " >> /etc/opendomo/speech/videomenu.txt
i=0
while read line
do	
	# only ports with way =out
	
	if [ `cat $line | grep -c "out"` -gt 0 ]
	then
		((i++))	
		#the switch, as seen in the tree /etc/opendomo/control, 
		#that will be similar in /var/opendomo/control...i guess	
		echo -n $line | sed -e "s/\/etc\/opendomo\/control//"g >> /etc/opendomo/speech/video.conf 
		echo -n ":" >> /etc/opendomo/speech/video.conf	
		#the name...	
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/video.conf
		#Generate videomenu.txt
		stri=`cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g` 		
		echo -n $stri >> /etc/opendomo/speech/videomenu.txt		
		echo -n " numero " >> /etc/opendomo/speech/videomenu.txt
		echo $i >> /etc/opendomo/speech/videomenu.txt	
		#Generate AYUDA 		
		echo -n "Activar video " >> /etc/opendomo/speech/AYUDA		
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/AYUDA
		echo -n "Desactivar video " >> /etc/opendomo/speech/AYUDA		
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

if  [ -f /etc/opendomo/speech/musicmenu.txt ]
then	
	rm /etc/opendomo/speech/musicmenu.txt
fi
touch /etc/opendomo/speech/musicmenu.txt
echo "Menu de musica. Para activar, diga activar numero. Para desactivar, diga desactivar numero" >> /etc/opendomo/speech/musicmenu.txt
i=0
while read line
do	
	# only ports with way =out
	
	if [ `cat $line | grep -c "out"` -gt 0 ]
	then
		((i++))
		#the switch, as seen in the tree /etc/opendomo/control, 
		#that will be similar in /var/opendomo/control...i guess	
		echo -n $line | sed -e "s/\/etc\/opendomo\/control//"g >> /etc/opendomo/speech/music.conf 
		echo -n ":" >> /etc/opendomo/speech/music.conf	
		#the name...	
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/music.conf
		#Generate musicmenu.txt
		stri=`cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g` 		
		echo -n $stri >> /etc/opendomo/speech/musicmenu.txt	
		echo -n " numero " >> /etc/opendomo/speech/musicmenu.txt
		echo $i >> /etc/opendomo/speech/musicmenu.txt	
		#Generate AYUDA 		
		echo -n "Activar musica " >> /etc/opendomo/speech/AYUDA		
		cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/AYUDA
		echo -n "Desactivar musica " >> /etc/opendomo/speech/AYUDA		
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

if  [ -f /etc/opendomo/speech/sensorsmenu.txt ]
then	
	rm /etc/opendomo/speech/sensorsmenu.txt
fi
touch /etc/opendomo/speech/sensorsmenu.txt
echo "Menu de sensores. Diga  numero de sensor que quiere leer" >> /etc/opendomo/speech/sensorsmenu.txt
i=0
while read line
do	
	# only ports really used...with tag assigned....maybe, later we have to prepare a different filter...
	
	if [ `cat $line | grep -c "tag"` -gt 0 ]
	then
		((i++))	
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
		#Generate sensorsmenu.txt
		echo -n $stri >> /etc/opendomo/speech/sensorsmenu.txt
		echo -n " numero " >> /etc/opendomo/speech/sensorsmenu.txt
		echo $i >> /etc/opendomo/speech/sensorsmenu.txt
		#Generate AYUDA 		
		echo -n "Informar de " >> /etc/opendomo/speech/AYUDA		
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


if  [ -f /etc/opendomo/speech/varlightmenu.txt ]
then	
	rm /etc/opendomo/speech/varlightmenu.txt
fi
touch /etc/opendomo/speech/varlightmenu.txt
echo "Menu de reguladores de luz. Diga valor mumero porcentaje de luz " >> /etc/opendomo/speech/varlightmenu.txt
i=0
while read line
do	
	# only ports with way =out
	
	if [ `cat $line | grep -c "out"` -gt 0 ]
	then
		if [ `cat $line | grep -c "analog"` -gt 0 ]
		then
			((i++))
			#the switch, as seen in the tree /etc/opendomo/control, 
			#that will be similar in /var/opendomo/control...i guess	
			echo -n $line | sed -e "s/\/etc\/opendomo\/control//"g >> /etc/opendomo/speech/varlight.conf 
			echo -n ":" >> /etc/opendomo/speech/varlight.conf
			#the name...
			cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/varlight.conf
			#Generate sensorsmenu.txt
			stri=`cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g` 		
			echo -n $stri >> /etc/opendomo/speech/varlightmenu.txt	
			echo -n " numero " >> /etc/opendomo/speech/varlightmenu.txt
			echo $i >> /etc/opendomo/speech/varlightmenu.txt
			#Generate AYUDA 		
			echo -n "Ajustar termostato " >> /etc/opendomo/speech/AYUDA		
			stri=`cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g`
			echo -n $stri >> /etc/opendomo/speech/AYUDA
			echo " valor, grados " >> /etc/opendomo/speech/AYUDA
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


if  [ -f /etc/opendomo/speech/varclimatemenu.txt ]
then	
	rm /etc/opendomo/speech/varclimatemenu.txt
fi
touch /etc/opendomo/speech/varclimatemenu.txt
echo "Menu de ajuste de temperatura. Diga valor numero temperatura en grados " >> /etc/opendomo/speech/varclimatemenu.txt
i=0
while read line
do	
	# only ports with way =out
	
	if [ `cat $line | grep -c "out"` -gt 0 ]
	then
		if [ `cat $line | grep -c "analog"` -gt 0 ]
		then
			((i++))
			#the switch, as seen in the tree /etc/opendomo/control, 
			#that will be similar in /var/opendomo/control...i guess	
			echo -n $line | sed -e "s/\/etc\/opendomo\/control//"g >> /etc/opendomo/speech/varclimate.conf 
			echo -n ":" >> /etc/opendomo/speech/varclimate.conf
			#the name...
			cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g >> /etc/opendomo/speech/varclimate.conf
			#Generate varlimatemenu.txt
			stri=`cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g` 		
			echo -n $stri >> /etc/opendomo/speech/varclimatemenu.txt	
			echo -n " numero " >> /etc/opendomo/speech/varclimatemenu.txt
			echo $i >> /etc/opendomo/speech/varclimatemenu.txt
			#Generate AYUDA 		
			echo -n "Ajustar luz " >> /etc/opendomo/speech/AYUDA		
			stri=`cat $line | grep zone | cut -d "=" -f2 - | sed s/"'"/""/g`
			echo -n $stri >> /etc/opendomo/speech/AYUDA
			echo " valor, porcentaje " >> /etc/opendomo/speech/AYUDA		
		fi
	fi
done < tmp.txt
echo " Zonas con reguladores de temperatura:"
cat /etc/opendomo/speech/varclimate.conf
#Generate AYUDA 		
echo "Ayuda OpenDomo " >> /etc/opendomo/speech/AYUDA		
			
