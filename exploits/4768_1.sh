#!/bin/sh
pid=0;
while x=0; do
/bin/ps -auxwwwp $pid | /usr/bin/grep $pid;
pid=`expr $pid + 1`;
done

