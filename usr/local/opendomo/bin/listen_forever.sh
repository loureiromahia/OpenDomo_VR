#!/bin/bash
/usr/bin/sox -t alsa default recording.flac silence 1 0.1 5% 1 1.0 5%
DATE=$(date +%Y%m%d%H%M%S)
mv recording.flac $DATE.recording.flac

