#!/bin/bash

# Install first dependencies.

sudo apt-get install sox python-argparse wget espeak xautomation xvkbd 

DIR="$(pwd)"
#Compiling dictionary.c:

echo Assuming all files are in "'$DIR'"

touch Recognition/dictionary.c
cd Recognition
make
cd ..
rm Recognition/modes/main.dic
rm Recognition/bin/ -r
rm $HOME/.palaver.d/plugins.db
rm $HOME/.palaver.d/UserInfo
rm $HOME/.palaver.d/configs -r
mkdir $HOME/.palaver.d/
cp Recognition/config/defaultBin Recognition/bin -r
touch $HOME/.palaver.d/UserInfo
cp Recognition/config/BlankInfo $HOME/.palaver.d/UserInfo
touch Recognition/modes/main.dic
cp Recognition/config/defaultMain.dic Recognition/modes/main.dic
./installDefault
./plugins -i ~/Plugins_SDK/OpenDomo_start/OpenDomo_start.sp
./plugins -i ~/Plugins_SDK/OpenDomo_stop/OpenDomo_stop.sp
echo "Install start_opendomoVR.sh to run forever in background" 
sudo update-rc.d start_opendomoVR.sh defaults

echo "Done: Now you can start Voice Recognition with: HOLA OPENDOMO"

