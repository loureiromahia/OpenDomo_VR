
The project Opendomo_VR is a Voice Recognition suite for OpenDomo and it is based on the job done in Palaver project

As reference, this is the github repository for PALAVER:

https://github.com/JamezQ/Palaver


And OpenDomo Project page:
 
http://www.opendomo.com/

INSTALLATION
============
1. BUILDING:

For building the package, run: 

	./mkpkg_opendomoVR.sh

This script will prepare the directory structure:

- /etc/init.d/start_opendomoVR.sh : script to run forever Opendomo_VR sw.
- ~/OpenDomo_VR : Operating SW
- ~/Plugings_SDK : Plugings for speech recognition commands
  

2. DEPENDENCIES:

# All these dependencies are checked in the setup script. This is just for your information.

sox
python-argparse

# For note to self

libsox-fmt-mp3
mutt

# Notification system:

notification-daemon,notify-osd or xfce4,notifyd

wget
espeak

# To send text

xvkbd

# For automation

xautomation



3.SETUP: 


In Opendomo_VR directory  , run the following command:

  		./setup_opendomoVR.sh
   
   This setup script will install logica_opendomo.sh to run forever every time the system is started and will let you customize your installation, depending on your preferences.

   Take into account that although the software is running forever, it is not so much time consuming, as the main action script does is to compare between two consecutive samples and deciding if it is new speech or not...Only in this case (new speech) it sends the speech sample to decode it.

The mechanism to decode the speech uses Google API recognition that has a very good recognition quality in the main languages. 

  
