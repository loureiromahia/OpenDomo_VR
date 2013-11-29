#!/bin/bash

rec recording.flac rate 16k silence 1 0.1 3% -1 3.0 3% &
p=$!
sleep 1
until [ "$var1" != "$var2" ]; do
    var1=`du "recording.flac"`
    sleep 1
    var2=`du "recording.flac"`
done
echo "Sound Detected"
until [ "$var1" == "$var2" ]; do
    var1=`du "recording.flac"`
    sleep 0.5
    var2=`du "recording.flac"`
done
echo "Silence Detected"

kill $p

RESULT="$(./send_speech recording.flac)"
./recognize "$RESULT"



