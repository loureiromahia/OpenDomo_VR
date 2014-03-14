#!/bin/bash
/usr/local/opendomo/services/config/about.sh > tmp.txt
echo "Informacion de instalacion OpenDomo" > about.txt
version=`grep INF tmp.txt |  cut -d ":" -f2 -`
echo "version  de OpenDomo " $version >> about.txt
kernel=`grep kernel tmp.txt | awk '{ print $5}'`
echo -n "Version del kernel " >> about.txt
echo $kernel >> about.txt
echo " Paquetes instalados " >> about.txt
for plugin in `grep version tmp.txt | cut -f1 -d.`
do
        echo $plugin >> about.txt
done


