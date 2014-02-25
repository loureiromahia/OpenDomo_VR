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

USER_DIR="/etc/opendomo/speech"
read ESPEAK < $USER_DIR/espeak.dat
grep $1 $USER_DIR/frases |cut -d ":" -f2 > FRASE
if [ $# -ge 2 ]; then
	grep $2 $USER_DIR/frases |cut -d ":" -f2 >> FRASE
fi
if [ $# -ge 3 ]; then
	grep $3 $USER_DIR/frases |cut -d ":" -f2 >> FRASE
fi
if [ $# -ge 4 ]; then
	grep $4 $USER_DIR/frases |cut -d ":" -f2 >> FRASE
fi	
		
$ESPEAK < FRASE
