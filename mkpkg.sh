#!/bin/bash
echo " To install, unpack the git directory at you home , keeping the actual structure of this directory"
echo "Make Directories: /usr/local/opendomo/vr and /usr/local/opendomo/voiceCommands"
sudo mkdir  -p /usr/local/opendomo/vr
sudo mkdir -p /usr/local/opendomo/voiceCommands
sudo chown -R 1000:1000 /usr/local/opendomo/vr
sudo chown -R 1000:1000 /usr/local/opendomo/voiceCommands


echo "Copy directory root files : * ==> /usr/local/opendomo/vr "
cp * /usr/local/opendomo/vr/.

echo "Copy operating files : ./src/usr/local/opendomo/vr  ==> /usr/local/opendomo/vr"
cp -r src/usr/local/opendomo/vr/* /usr/local/opendomo/vr/.

echo "Copy plugin files : ./src/usr/local/opendomo/voiceCommands /usr/local/opendomo/voiceCommands "
cp -r src/usr/local/opendomo/voiceCommands/* /usr/local/opendomo/voiceCommands/.

echo "Copy documentation files : ./doc  ==> /usr/local/opendomo/vr/doc"
mkdir -p /usr/local/opendomo/vr/doc
cp -r doc/* /usr/local/opendomo/vr/doc/.

echo "Copy test files : ./test  ==> /usr/local/opendomo/vr/test "
mkdir -p /usr/local/opendomo/vr/test
cp -r doc/* /usr/local/opendomo/vr/test/.

echo "Copy initialization files : ./src/etc/init.d/start_opendomoVR.sh  ==> /etc/init.d/start_opendomoVR.sh "
sudo cp  src/etc/init.d/start_opendomoVR.sh  /etc/init.d/start_opendomoVR.sh


echo "DONE!!!"
echo "Now you can start setting up OpenDomo voice recognition SW"
echo "By running : ./setup_opendomoVR.sh  in directory: /usr/local/opendomo/vr"


