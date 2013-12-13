#!/bin/bash

# Install first dependencies.

sudo apt-get install make gcc sox python-argparse wget espeak xautomation xvkbd 
#For OpenDomo we are going to use /etc/opendomo/speech, instead of $HOME/.palaver.d/
CONFIGDIR="/etc/opendomo/speech"
DIR="$(pwd)"
#Compiling dictionary.c:

#echo Assuming all files are in "'$DIR'"

#touch Recognition/dictionary.c
#cd Recognition
#make
#cd ..
echo "Clean directories from previous installations"
rm Recognition/modes/main.dic
rm Recognition/bin/ -r
rm $CONFIGDIR/plugins.db
rm $CONFIGDIR/UserInfo
rm $CONFIGDIR/configs -r

#mkdir $HOME/.palaver.d/
sudo mkdir -p $CONFIGDIR
sudo chown -R 1000:1000 $CONFIGDIR
#Atentos!!...cambiar el owner...Usamos 1000:1000 para ser compatible : opendomo: admin,,, mi instalación: manu
cp Recognition/config/defaultBin Recognition/bin -r
#touch $HOME/.palaver.d/UserInfo
touch $CONFIGDIR/UserInfo
#cp Recognition/config/BlankInfo $HOME/.palaver.d/UserInfo
cp Recognition/config/BlankInfo $CONFIGDIR/UserInfo
touch Recognition/modes/main.dic
cp Recognition/config/defaultMain.dic Recognition/modes/main.dic
#Solo instalamos lo específico de Opendomo
read IDIOMA < /etc/opendomo/lang
if [ "$IDIOMA" == "es" ]  
then	
	Bucle=true
	while $Bucle 
	do
	
		read -p "¿Usar voz de Antonio o de Marta (A/M)? " -n1 answer
		if [ "$answer" == "A" ]
		then
			cp /usr/local/opendomo/vr/characters/antonio.es/* /etc/opendomo/speech/.
			Bucle=false
		elif [ "$answer" == "M" ]
		then
			cp /usr/local/opendomo/vr/characters/marta.es/* /etc/opendomo/speech/.
			Bucle=false
		else
			echo "Introduce A (Antonio) o M (Marta)"			
			Bucle=true			
		fi
	done
else
	Bucle=true
	while $Bucle 
	do
	
		read -p "Do you want to use the voice from Paul or from Mary (P/M)? " -n1 answer
		if [ "$answer" == "P" ]
		then
			cp /usr/local/opendomo/vr/characters/paul.en/* /etc/opendomo/speech/.
			Bucle=false
		elif [ "$answer" == "M" ]
		then
			cp /usr/local/opendomo/vr/characters/mary.en/* /etc/opendomo/speech/.
			Bucle=false
		else
			echo "Enter P (Paul) or M (Mary)"			
			Bucle=true			
		fi
	done
fi

#./installDefault
./plugins -i /usr/local/opendomo/voiceCommands/$IDIOMA/OpenDomo_start/OpenDomo_start.sp
./plugins -i /usr/local/opendomo/voiceCommands/$IDIOMA/OpenDomo_stop/OpenDomo_stop.sp
./plugins -i /usr/local/opendomo/voiceCommands/$IDIOMA/LucesON/LucesON.sp
./plugins -i /usr/local/opendomo/voiceCommands/$IDIOMA/LucesOFF/LucesOFF.sp
./plugins -i /usr/local/opendomo/voiceCommands/$IDIOMA/ClimaON/ClimaON.sp
./plugins -i /usr/local/opendomo/voiceCommands/$IDIOMA/ClimaOFF/ClimaOFF.sp
./plugins -i /usr/local/opendomo/voiceCommands/$IDIOMA/Sensors/Sensors.sp
./plugins -i /usr/local/opendomo/voiceCommands/$IDIOMA/VideoON/VideoON.sp
./plugins -i /usr/local/opendomo/voiceCommands/$IDIOMA/VideoOFF/VideoOFF.sp
./plugins -i /usr/local/opendomo/voiceCommands/$IDIOMA/MusicON/MusicON.sp
./plugins -i /usr/local/opendomo/voiceCommands/$IDIOMA/MusicOFF/MusicOFF.sp
./plugins -i /usr/local/opendomo/voiceCommands/$IDIOMA/VarLight/VarLight.sp
./plugins -i /usr/local/opendomo/voiceCommands/$IDIOMA/VarClimate/VarClimate.sp
echo "Install start_opendomoVR.sh to run forever in background" 
sudo update-rc.d start_opendomoVR.sh defaults

echo "Done: Now you can start Voice Recognition with: HOLA OPENDOMO"

