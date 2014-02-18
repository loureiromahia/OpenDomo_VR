INTRODUCTION:
=============

OpenDomo_VR is a Voice Recognition suite, adapted for OpenDomo OS Project

The project using Google Voice Recognition API,which is today the "state of art" in generic Voice Recognition:
- It is working in most common languages (this project is designed to work with english and spanish) 
- It is working with a high variety of speakers within those languages (gender,age, locale accent..)

The kind of commands to recognize are:
	
	Switch On /Off Light in a room (kitchen, living room, wc...)
	Switch On /Off Clima in a room (kitchen, living room, wc...)
	Switch On /Off Music in a room (kitchen, living room, wc...)
	Switch On /Off Video in a room (kitchen, living room, wc...)
	Change the temperature in a room (kitchen, living room, wc...)
	Read a specific sensor in a room (kitchen, living room, wc...)
	........

As a result of these commands, OpenDomo_VR will act on the specific port to perform action requested by the user.  

OpenDomo_VR is designed to be multilanguage. In the first version , English and Spanish languages are supported. More Languages can be added  easily: it is a matter of adapting the voiceCommand to that language. There you can define, the voice to be recognized and the phrases to be provided by the system.

Furthermore, OpenDomo_VR, is "Character" driven: You can define a speaker(Character) to answer your commands (defining the gender, age, formal or  casual answer, ...)


INSTALLATION
============

1. BUILDING:

For building the package, install from git in OpenDomo: 

./plugin_add_from_gh.sh loureiromahia OpenDomo_VR

This script will prepare the directory structure:

- /usr/local/opendomo/vr  		Operating SW
- /usr/local/opendomo/voiceCommands  	Speech recognition commands
- /usr/local/opendomo/services/config 	Configuration scripts
- /usr/local/opendomo/daemons 	 	Daemons to be installed   

2. DEPENDENCIES:

# All these dependencies are checked in the setup script. This is just for your information.

sox
python-argparse
espeak 
flac



3.SETUP: 


In OpenDomo config directory (/usr/local/opendomo/services/config)  , run the following command:

  		./configureVoiceSystem.sh $1

$1 Parameter defines the Voice Character for voice sinthesis. In the Voice Character you can define the follwing properties:
 
- Voice Pitch and Gender
- Phrases: there you can define voice answer to your comand:
	For instance, to aknowledge a command ,system can say:
			Understood
			I have understood your command
			OK
			....
	In this file is stored the answer the system is going to provide you for each command/event
		
			
What is configured:

- Language: extracted from system configuration in Opendomo
- Voice Character (Pitch/Phrases)
- Commands and Actions to be done (VoiceCommands)
- Specific configuration files for base recognition: Sw specific for Hw architecture, base sw  for recognition, dictionaries....  

Where is configured:

	/etc/opendomo/speech
    

This setup script will install opendomoVR.sh to run forever every time the system is started and will let you customize your installation, depending on your preferences.

   Take into account that although the software is running forever, it is not so much time consuming, as the main action script does is to compare between two consecutive samples and deciding if it is new speech or not...Only in this case (new speech) it sends the speech sample to decode it.

The mechanism to decode the speech uses Google API recognition that has a very good recognition quality in the main languages. 


EXECUTION
=========

If Voice Recognition is not autostarted with previous script (./configureVoiceSystem.sh), you can always run it manually executing:

	/usr/local/opendomo/vr/opendomoVR.sh
 
Every time that this program is started, it checks the configuration of each installation, generating the configuration files for every of the voice managed services: Clima, Lights, Sensors, Music, Video....This configuration files are stored in:
			
	/etc/opendomo/speech
 


OPERATION MODES:

OpenDomo_VR has two MODEs of operation:

- Identification: In this mode OpenDomo_VR only accepts the voice command "Hello XXXX", where XXXX is the name of the installation.

- Normal: After a correct Identification, OpenDomo_VR switches to MODE =Normal. In this mode  OpenDomo recognizes all the defined voice commands for this installation (switch on/off lights, music control...). OpenDomo_VR keeps in this mode until a "Bye" Voice Command is issued. If this Bye is  issued , OpenDomo_VR switch again to Identification MODE, not accepting a new command until a correct identification is issued.

Note that all these status are Operational OpenDomo_VR Modes. When the user is not in the installation, or during the night(while he is sleeping) OpenDomo_VR  daemon is not running.


REFERENCES:
===========

OpenDomo Project page:
 
http://www.opendomo.com/   


The project Opendomo_VR it is based on the job done in Palaver project.As reference, this is the github repository for PALAVER:

https://github.com/JamezQ/Palaver


