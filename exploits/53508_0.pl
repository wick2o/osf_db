#!/usr/bin/perl -w
$filename="a"x129;
print "------Generate testfile \"a\"x129.epub------\n";
open(TESTFILE, ">$filename.epub");
sleep(3);
close(TESTFILE);
print "------Complete!------\n";
exit(1);

