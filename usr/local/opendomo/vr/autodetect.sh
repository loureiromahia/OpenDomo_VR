#!/bin/bash
play BEEP1.WAV
rec recording.flac rate 16k silence 1 0.1 3% 1 15.0 3% &
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

if [ `ps -eaf | grep -c $p` -gt 1 ] 
#grep is 1...minimum value is 1
then
	kill $p
fi

./send_speech recording.flac
RESULT=`cat result.json | cut -d":" -f4 |cut -d"," -f1 | sed 's/"//g'`
RESULT=`echo "${RESULT:1:${#RESULT}-1}"`
RETRY1=`cat result.json | cut -d":" -f6 |cut -d"," -f1 | sed 's/"//g' | sed 's/}//g'`
RETRY1=`echo "${RETRY1:1:${#RETRY1}-1}"`
RETRY2=`cat result.json | cut -d":" -f7 |cut -d"," -f1 | sed 's/"//g' | sed 's/}//g'`
RETRY2=`echo "${RETRY2:1:${#RETRY2}-1}"`
./recognize "$RESULT" 
resultado=`cat RESULTADO`
#if not OK, retry twice 
if [ "$resultado" == "NOK" ]
then
	RETRY1=`cat result.json | cut -d":" -f6 |cut -d"," -f1 | sed 's/"//g' | sed 's/}//g'`
	RETRY1=`echo "${RETRY1:1:${#RETRY1}-1}"`
	./recognize "$RETRY1" 
	resultado=`cat RESULTADO`
	if [ "$resultado" == "NOK" ]
	then
		RETRY2=`cat result.json | cut -d":" -f7 |cut -d"," -f1 | sed 's/"//g' | sed 's/}//g'`
		RETRY2=`echo "${RETRY2:1:${#RETRY2}-1}"
		./recognize "$RETRY2" 
		resultado=`cat RESULTADO`
		if [ "$resultado" == "NOK" ]
		then`
			/usr/local/opendomo/vr/espeak.sh "NoEntendido"
     		fi
	fi
fi


