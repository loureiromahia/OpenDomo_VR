#!/bin/bash
# Check Parameters: Only 1 (voice type)
# To run this script , as there are parts in which it needs to run sudo command, it is necessary to edit /etc/sudoers file, 
# adding this line: %manu ALL=(ALL) NOPASSWD: NOPASSWD: ALL

if [ $# -ne 1 ]; then
    echo "Your command line contains $# arguments"
    echo "Usage: ./setup_opendomoVR.sh PARAM1"
    echo " PARAM1: A/M    A: Voz de Antonio ,, M: Voz de Marta"
    echo " PARAM1: A/M    A: Voice from Arthur ,, M: Voice from Mary"
    exit 0
fi
 


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

if [ "$IDIOMA" == "es" ]  
then	

		if [ "$1" == "A" ]
		then
			cp /usr/local/opendomo/vr/characters/antonio.es/* /etc/opendomo/speech/.
		
		elif [ "$1" == "M" ]
		then
			cp /usr/local/opendomo/vr/characters/marta.es/* /etc/opendomo/speech/.
			
		else
			echo "Introduce A (Antonio) o M (Marta)"			
			exit 0			
		fi
	
else

		if [ "$1" == "A" ]
		then
			cp /usr/local/opendomo/vr/characters/paul.en/* /etc/opendomo/speech/.
		
		elif [ "$1" == "M" ]
		then
			cp /usr/local/opendomo/vr/characters/mary.en/* /etc/opendomo/speech/.
		
		else
			echo "Enter P (Paul) or M (Mary)"			
			exit 0			
		fi
fi
#./installDefault
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
echo "Install start_opendomoVR.sh to run forever in background" 
sudo update-rc.d opendomoVRd defaults 99
#Create the file /etc/opendomo/speech/SETUPDONE, to indicate that setup has been alerady performed
#When running the voice recognition, opendomoVR.sh will check if this file exists, if not, it will run automatically the setup, with default parameter.
touch $CONFIGDIR/SETUPDONE
echo "Done: Now you can start Voice Recognition with: HOLA OPENDOMO"

