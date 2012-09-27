$TRXID=$ARGV[0];
$zero=$TRXID>>14;
if ($zero!=0)
{
	print "Highest two bits are not 0.\n";
print "Is this really Windows DNS server? check endian issues!\n";
	exit(0);
}
$M=($TRXID>>11) & 7;
$C=($TRXID>>3) & 0xFF;
$L=$TRXID & 7;
if (($C % 8)!=7)
{
	print "C mod 8 is not 7 - can't predict next TRXID.\n";
print "Wait for C mod 8 to become 7\n";
	exit(0);
}

print "Next TRXID is one of the following 8 values:\n";
for ($m=0;$m<8;$m++)
{
	print "".(($m<<11)|((($C+1) % 256)<<3))." ";
}
print "\n";