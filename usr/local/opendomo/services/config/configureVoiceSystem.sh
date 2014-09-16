#!/bin/bash
#desc:Configure Voice System
# Check Parameters: Only 1 (voice type)
# To run this script , as there are parts in which it needs to run sudo command, it is necessary to edit /etc/sudoers file, 
# adding this line: %manu ALL=(ALL) NOPASSWD: NOPASSWD: ALL

CHARDIR="/usr/local/opendomo/vr/characters"
CONFIGDIR="/etc/opendomo/speech"

read IDIOMA < /etc/opendomo/lang
if ! test -d "$CHARDIR/$IDIOMA"; then
	IDIOMA="en"
fi

cd $CHARDIR/$IDIOMA
VOICES=`ls -dx * | sed 's/ /,/g'`

if test -z "$1"; then
	echo "#> Select character"
    echo "list:`basename $0`	iconlist"
	for i in *; do
		if test -d ./$i && test "$i" != "*"
		then
			echo "	-$i	$i	character"
		fi
	done
	
    #echo "	voice	Voice	list[$VOICES]"
    echo
#  Skip interactive messages: 
#    echo "Your command line contains $# arguments"
#    echo "Usage: ./configureVoiceSystem.sh PARAM1"
#    echo " PARAM1: A/M    A: Voz de Antonio ,, M: Voz de Marta"
#    echo " PARAM1: A/M    A: Voice from Arthur ,, M: Voice from Mary"
    exit 0
else
	if test -d "$CHARDIR/$IDIOMA/$1/"
	then
		cp $CHARDIR/$IDIOMA/$1/* $CONFIGDIR/.
	else
		echo "#ERR: Character directory does not exist"
		exit 1
	fi
fi
 

#if [ -f $CHARDIR/$IDIOMA/$1/espeak.dat ]  
#then	
#	cp $CHARDIR/$IDIOMA/$1/* $CONFIGDIR/.
#else
#	echo "#> Select character"
#	echo "form:`basename $0`"
#	echo "	voice	Voice	list[$VOICES]"
#    echo
#	exit 0
#fi
 

# Install first dependencies.
# 
#sudo apt-get install make gcc sox python-argparse wget espeak xautomation xvkbd 
#gcc and make are not necessary: No compilation will be done in Production Systems. Only used in development 
#  
# sudo apt-get install sox python-argparse espeak flac  # DEPRECATED (this is done by installPlugin script)

#For OpenDomo we are going to use $CONFIGDIR, instead of $HOME/.palaver.d/

cd /usr/local/opendomo/vr
DIR="$(pwd)"
# As mentioned above, no compilation will be done in Production environment.
# So, next steps are skipped in Production deliverable
#
#Compiling dictionary.c:
#echo Assuming all files are in "'$DIR'"
#touch Recognition/dictionary.c
#cd Recognition
#make
#cd ..
#
#INSTEAD:
#Copy precompiled version adapted to HW architecture, checking /proc/cpuinfo:
#
ISARM=`grep -c ARM /proc/cpuinfo`
if [ $ISARM -ne 1 ]
then
	echo "Configurado dictionary para arquitectura i686"	
	cp Recognition/dictionary.i686 Recognition/dictionary
else
	echo "Configurado dictionary para arquitectura ARM"	
	cp Recognition/dictionary.ARM Recognition/dictionary
fi
#

echo "Clean directories from previous installations"
rm Recognition/modes/main.dic
rm Recognition/bin/ -r
rm $CONFIGDIR/plugins.db
rm $CONFIGDIR/UserInfo
rm $CONFIGDIR/config -r

mkdir -p $CONFIGDIR
chown -R 1000:1000 $CONFIGDIR
#Changed the owner to 1000:1000...in opendomo: admin,,, in normal Debian installations: user id
cp Recognition/config/defaultBin Recognition/bin -r

touch $CONFIGDIR/UserInfo

cp Recognition/config/BlankInfo $CONFIGDIR/UserInfo
touch Recognition/modes/main.dic
cp Recognition/config/defaultMain.dic Recognition/modes/main.dic
#
#read IDIOMA < /etc/opendomo/lang
#As the configuration will be adapted to use CGI Opendomo interface, this script will no longer be interactive,and so
# all this code is no longer valid:
#
#if [ "$IDIOMA" == "es" ]  
#then	
#	Bucle=true
#	while $Bucle 
#	do
#	
#		read -p "¿Usar voz de Antonio o de Marta (A/M)? " -n1 answer
#		if [ "$answer" == "A" ]
#		then
#			cp $CHARDIR/antonio.es/* $CONFIGDIR/.
#			Bucle=false
#		elif [ "$answer" == "M" ]
#		then
#			cp $CHARDIR/marta.es/* $CONFIGDIR/.
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
#			cp $CHARDIR/paul.en/* $CONFIGDIR/.
#			Bucle=false
#		elif [ "$answer" == "M" ]
#		then
#			cp $CHARDIR/mary.en/* $CONFIGDIR/.
#			Bucle=false
#		else
#			echo "Enter P (Paul) or M (Mary)"			
#			Bucle=true			
#		fi
#	done
#fi
#
#Instead , user has to issue the character to be configured in the initial script:  this script will be launched 
#from web interface:
#  
#if [ -f $CHARDIR/$IDIOMA/$1/espeak.dat ]  
#then	
#	cp $CHARDIR/$IDIOMA/$1/* $CONFIGDIR/.
#else
#	echo "#> Select character"
#	echo "form:`basename $0`"
#	echo "	voice	Voice	list[$VOICES]"
#	echo
#	exit 0
#fi
#fi

# Next command is not necessary, as all the commands will be explicitly installed using plugins commands  
#./installDefault
cd /usr/local/opendomo/vr
cp generate_port_data_$IDIOMA.sh generate_port_data.sh
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
./plugins -f -i /usr/local/opendomo/voiceCommands/$IDIOMA/Ayuda/Ayuda.sp
./plugins -f -i /usr/local/opendomo/voiceCommands/$IDIOMA/menu/menu.sp
##Next changes are no longer necessary, as the procedures to autostart forever, will be perormed, using 
## OpenDomo specific procedures.
#
#echo "Install voiceSystem.sh , so that opendomoVR.sh run forever in background" 
#sudo cp /usr/local/opendomo/daemons/voiceSystem.sh /etc/init.d/.
#sudo update-rc.d voiceSystem.sh defaults 99
#Create the file $CONFIGDIR/SETUPDONE, to indicate that setup has been already performed
#When running the voice recognition, opendomoVR.sh will check if this file exists, if not, it will run automatically the #setup, with default parameter.
#
#echo "Create SETUPDONE file, to indicate setup has been already performed"
touch $CONFIGDIR/SETUPDONE
echo "#INFO System successfully configured"
echo "#INFO Now you can start Voice Recognition issuing a voice identification command (usually something like:HOLA OPENDOMO)"

