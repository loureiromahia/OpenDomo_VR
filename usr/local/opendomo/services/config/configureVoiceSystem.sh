#!/bin/bash
#desc:Configure Voice System
# Check Parameters: Only 1 (voice type)
# To run this script , as there are parts in which it needs to run sudo command, it is necessary to edit /etc/sudoers file, 
# adding this line: %manu ALL=(ALL) NOPASSWD: NOPASSWD: ALL
read IDIOMA < /etc/opendomo/lang
cd /usr/local/opendomo/vr/characters/
VOICES=`ls -dx *.$IDIOMA | sed 's/ /,/g'`

if [ $# -ne 1 ]; then
    echo "usage:`basename $0`"
    echo "	voice	Voice	list[$VOICES]"
    echo
#    echo "Your command line contains $# arguments"
#    echo "Usage: ./configureVoiceSystem.sh PARAM1"
#    echo " PARAM1: A/M    A: Voz de Antonio ,, M: Voz de Marta"
#    echo " PARAM1: A/M    A: Voice from Arthur ,, M: Voice from Mary"
    exit 0
fi
 


# Install first dependencies.

#sudo apt-get install make gcc sox python-argparse wget espeak xautomation xvkbd 
# gcc and make are not necessary: No compilation will be done in Production Systems. Only used in development  
sudo apt-get install sox python-argparse espeak flac 
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
#if [ "$IDIOMA" == "es" ]  
#then	
#	Bucle=true
#	while $Bucle 
#	do
#	
#		read -p "¿Usar voz de Antonio o de Marta (A/M)? " -n1 answer
#		if [ "$answer" == "A" ]
#		then
#			cp /usr/local/opendomo/vr/characters/antonio.es/* /etc/opendomo/speech/.
#			Bucle=false
#		elif [ "$answer" == "M" ]
#		then
#			cp /usr/local/opendomo/vr/characters/marta.es/* /etc/opendomo/speech/.
#			Bucle=false
#		else
#			echo "Introduce A (Antonio) o M (Marta)"			
#			Bucle=true			
#		fi
#	done
#else
#	Bucle=true
#	while $Bucle 
#	do
#	
#		read -p "Do you want to use the voice from Arthur or from Mary (A/M)? " -n1 answer
#		if [ "$answer" == "A" ]
#		then
#			cp /usr/local/opendomo/vr/characters/paul.en/* /etc/opendomo/speech/.
#			Bucle=false
#		elif [ "$answer" == "M" ]
#		then
#			cp /usr/local/opendomo/vr/characters/mary.en/* /etc/opendomo/speech/.
#			Bucle=false
#		else
#			echo "Enter P (Paul) or M (Mary)"			
#			Bucle=true			
#		fi
#	done
#fi

if [ -f /usr/local/opendomo/vr/characters/$1/espeak.dat ]  
then	
	cp /usr/local/opendomo/vr/characters/$1/* /etc/opendomo/speech/.
		
else
	echo "usage:`basename $0`"
	echo "	voice	Voice	list[$VOICES]"
    	echo
	exit 0
		
fi
#./installDefault
cd /usr/local/opendomo/vr
./plugins -f -i /usr/local/opendomo/voiceCommands/$IDIOMA/OpenDomo_start/OpenDomo_start.sp
./plugins -f -i /usr/local/opendomo/voiceCommands/$IDIOMA/OpenDomo_stop/OpenDomo_stop.sp
./plugins -f -i /usr/local/opendomo/voiceCommands/$IDIOMA/LucesON/LucesON.sp
./plugins -f -i /usr/local/opendomo/voiceCommands/$IDIOMA/LucesOFF/LucesOFF.sp
./plugins -f -i /usr/local/opendomo/voiceCommands/$IDIOMA/ClimaON/ClimaON.sp
./plugins -f -i /usr/local/opendomo/voiceCommands/$IDIOMA/ClimaOFF/ClimaOFF.sp
./plugins -f -i /usr/local/opendomo/voiceCommands/$IDIOMA/Sensors/Sensors.sp
./plugins -f -i /usr/local/opendomo/voiceCommands/$IDIOMA/VideoON/VideoON.sp
./plugins -f -i /usr/local/opendomo/voiceCommands/$IDIOMA/VideoOFF/VideoOFF.sp
./plugins -f -i /usr/local/opendomo/voiceCommands/$IDIOMA/MusicON/MusicON.sp
./plugins -f -i /usr/local/opendomo/voiceCommands/$IDIOMA/MusicOFF/MusicOFF.sp
./plugins -f -i /usr/local/opendomo/voiceCommands/$IDIOMA/VarLight/VarLight.sp
./plugins -f -i /usr/local/opendomo/voiceCommands/$IDIOMA/VarClimate/VarClimate.sp
echo "Install voiceSystem.sh , so that opendomoVR.sh run forever in background" 
sudo update-rc.d voiceSystem.sh defaults 99
#Create the file /etc/opendomo/speech/SETUPDONE, to indicate that setup has been alerady performed
#When running the voice recognition, opendomoVR.sh will check if this file exists, if not, it will run automatically the setup, with default parameter.
touch $CONFIGDIR/SETUPDONE
echo "Done: Now you can start Voice Recognition with: HOLA OPENDOMO"

