my $file= "1.cda";
my $junk = "\x41" x 1000;
open($FILE,">$file");
print $FILE $junk;
close($FILE);
print "File Created successfully\n";
sleep(1);
