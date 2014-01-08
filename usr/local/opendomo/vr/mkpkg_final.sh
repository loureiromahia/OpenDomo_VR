#!/bin/bash
echo " To install, unpack the git directory at you home , keeping the actual structure of this directory"
echo "Make Directories: /usr/local/opendomo/vr and /usr/local/opendomo/voiceCommands"

tar cvfz $oddevel-`date '+%Y%m%d'`.od.noarch.tar.gz usr var --owner 1000 --group 1000 --exclude "*~" --exclude .svn --exclude "*.a"


echo "DONE!!!"
echo "Now you can start setting up OpenDomo voice recognition SW"
echo "By running : ./setup_opendomoVR.sh  in directory: /usr/local/opendomo/vr"


