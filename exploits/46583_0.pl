my $file = "dniz0r.pj";
my $data = ""; #my $data = "J" x(2+2);
open($FILE,">$file");
print $FILE $data;
close($FILE);
print "\npj File Created successfully\n";