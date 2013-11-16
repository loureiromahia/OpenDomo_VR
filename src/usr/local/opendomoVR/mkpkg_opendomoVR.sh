#!/bin/bash
echo " To install, unpack the git directory at you home , keeping the actual structure of this directory"
echo "Make Directories:  ~/OpenDomo_VR nad ~/Plugins_SDK"
mkdir ~/OpenDomo_VR
mkdir ~/Plugings_SDK

echo "Copy directory root files : * ==> ~/OpenDomo_VR "
cp * ~/OpenDomo_VR/.

echo "Copy operating files : ./src/usr/local/opendomoVR  ==> ~/OpenDomo_VR "
cp -r src/local/opendomoVR/* ~/OpenDomo_VR/.

echo "Copy plugin files : ./src/usr/local/Plugins_SDK  ==> ~/Plugins_SDK "
cp -r src/local/Plugins_SDK/* ~/Plugins_SDK/.

echo "Copy documentation files : ./doc  ==> ~/OpenDomo_VR/doc/. "
mkdir ~/OpenDomo_VR/doc
cp -r doc/* ~/OpenDomo_VR/doc/.

echo "Copy test files : ./test  ==> ~/OpenDomo_VR/test/. "
mkdir ~/OpenDomo_VR/test
cp -r doc/* ~/OpenDomo_VR/test/.

echo "Copy initialization files : ./src/etc/init.d/start_opendomoVR.sh  ==> /etc/init.d/start_opendomoVR.sh "
gksu -u root "cp  src/etc/init.d/start_opendomoVR.sh  /etc/init.d/start_opendomoVR.sh "


echo "Done: Now you can start setting up OpenDomo voice recognition SW"
echo "By running : ./setup_opendomoVR.sh  in directory: ~/OpenDomo_VR"


