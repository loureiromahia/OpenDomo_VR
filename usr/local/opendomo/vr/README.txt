
The project Opendomo_VR is a Voice Recognition suite for OpenDomo and it is based on the job done in Palaver project

As reference, this is the github repository for PALAVER:

https://github.com/JamezQ/Palaver


And OpenDomo Project page:
 
http://www.opendomo.com/

INSTALLATION
============
1. BUILDING:

For building the package, run: 

	./mkpkg.sh

This script will prepare the directory structure:

- /etc/init.d/start_opendomoVR.sh : script to run forever Opendomo_VR sw.
- /usr/local/opendomo/vr : Operating SW
- /usr/local/opendomo/voiceCommands : Speech recognition commands
  

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


In Opendomo_VR directory (/usr/local/opendomo/vr)  , run the following command:

  		./setup_opendomoVR.sh
   
   This setup script will install opendomoVR.sh to run forever every time the system is started and will let you customize your installation, depending on your preferences.

   Take into account that although the software is running forever, it is not so much time consuming, as the main action script does is to compare between two consecutive samples and deciding if it is new speech or not...Only in this case (new speech) it sends the speech sample to decode it.

The mechanism to decode the speech uses Google API recognition that has a very good recognition quality in the main languages. 

4. EXECUTING:

OpenDomo_VR has two MODEs of operation:
- Identification: In this mode OpenDomo_VR only accepts the voice command "Hello XXXX", where XXXX is the name of the installation.
- Normal: After a correct Identification, OpenDomo_VR switches to MODE =Normal. In this mode  OpenDomo recognizes all the defined voice commands for this installation (switch on/off lights, music control...). OpenDomo_VR keeps in this mode until a "Bye" Voice Command is issued. If this Bye is  issued , OpenDomo_VR switch again to Identification MODE, not accepting a new command until a correct identification is issued.

Note that all these status are Operational OpenDomo_VR Modes. When the user is not in the installation, or during the night(while he is sleeping) OpenDomo_VR  daemon is not running.   
