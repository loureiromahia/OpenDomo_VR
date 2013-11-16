#!/bin/bash
### BEGIN INIT INFO
# Provides:          Automatic Voice Recognition fo Open Domo
# Required-Start:    $syslog
# Required-Stop:     $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Automatic Voice Recognition fo Open Domo
# Description:
#
### END INIT INFO
echo "Setting up customized environment..."
~/OpenDomo_VR/logica_opendomo.sh
