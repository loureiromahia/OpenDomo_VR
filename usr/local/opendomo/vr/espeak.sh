#!/bin/bash

   # This program is free software: you can redistribute it and/or modify
   #  it under the terms of the GNU General Public License as published by
   #  the Free Software Foundation, either version 3 of the License, or
   #  (at your option) any later version.

   #  This program is distributed in the hope that it will be useful,
   #  but WITHOUT ANY WARRANTY; without even the implied warranty of
   #  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   #  GNU General Public License for more details.

   #  You should have received a copy of the GNU General Public License
   #  along with this program.  If not, see <http://www.gnu.org/licenses/>.
# TODO, make this use the mode, context and custom sed script

TMPFILE="/var/opendomo/tmp/speech.tmp"
CFGFILE="/etc/opendomo/speech/espeak.conf"
source $CFGFILE

grep $1 $USER_DIR/frases |cut -d ":" -f2 > $TMPFILE
if [ $# -ge 2 ]; then
	grep $2 $USER_DIR/frases |cut -d ":" -f2 >> $TMPFILE
fi
if [ $# -ge 3 ]; then
	grep $3 $USER_DIR/frases |cut -d ":" -f2 >> $TMPFILE
fi
if [ $# -ge 4 ]; then
	grep $4 $USER_DIR/frases |cut -d ":" -f2 >> $TMPFILE
fi	
		
/usr/bin/espeak $PARAMS `cat $TMPFILE` 2>/dev/null
