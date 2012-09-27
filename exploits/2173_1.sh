#!/bin/sh

HOST=$1
PATH=$2

start()
{
	/usr/bin/lynx -dump http://$HOST/.nsf/../$PATH
}


if [ -n "$HOST" ]; then 
        start
else
        echo "$0 <host> <path>"
fi

