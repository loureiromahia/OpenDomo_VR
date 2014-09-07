#!/bin/sh
#desc:Say
#type:local
#package:odvr
# Copyright(c) 2014 OpenDomo Services SL. Licensed under GPL v3 or later

CFGFILE="/etc/opendomo/speech/espeak.conf"

if test -x /usr/bin/espeak  && test -f "$CFGFILE"
then
	source $CFGFILE
	/usr/bin/espeak $PARAMS "$1" 2>/dev/null
else
	exit 1
fi
