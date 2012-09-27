#!/usr/bin/perl
#
# Written by rain_song
#
# input file should only contain the main "encrypted" string, which is the 2nd
# javascript variable in the HTML source code.
#

if( $#ARGV != 0 )
{
	print "\nWritten by rain_song";
	print "\nUsage: $0 input_file\n";
	print "\tinput_file should only contain 2nd JS variable of HTML page (it\n";
	print "\t  is the biggest variable)\n\n";
	exit( 0 );
}

open( INPUT, "<$ARGV[0]" ) or die;

$encrypted = <INPUT>;
close( INPUT );
$length = length($encrypted);

$string1 = substr( $encrypted, 0, $length/2 );
$string2 = substr( $encrypted, $length/2, $length-1 );

$i = 0;
while( $i < length($string1) )
{
	$decrypted .= substr( $string1, $i, 1 ) . substr( $string2, $i, 1 );
	$i++;
}

$decrypted =~ s/\\/\@\@/g;
$decrypted =~ s/\'/\`/g;
$decrypted =~ s/qg/\r\n/g;

print $decrypted;
