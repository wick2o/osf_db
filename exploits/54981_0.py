#!/usr/bin/python
 
import socket
 
buffer1= "[AAAA]"  * 500
buffer2= "BBBB"  * 6000
 
print "\nSending buffer 1"
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(('xxx.xxx.xxx.xxx',5591))
s.send(buffer1)
s.close()
 
raw_input()
 
print "\nSending buffer 2"
s2 = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s2.connect(('xxx.xxx.xxx.xxx',5591))
s2.send(buffer2)
s2.close()
