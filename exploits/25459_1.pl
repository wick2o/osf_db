$TRXID1=$ARGV[0];
$TRXID2=$ARGV[1];
$TRXID3=$ARGV[2];

$d1=($TRXID2-$TRXID1) % 65536;
if (($d1 & 1) == 0)
{
	die "Impossible: d1 is even";
}
	
$d2=($TRXID3-$TRXID2) % 65536;
if (($d2 & 1) == 0)
{
	die "Impossible: d2 is even";
}

# Calculate $inv_d1=($d1)^(-1)
$inv_d1=1;
for (my $b=1;$b<=16;$b++)
{
	if ((($d1*$inv_d1) % (1<<$b))!=1)
	{
		$inv_d1|=(1<<($b-1));
	}
}
			
my $a=($inv_d1 * $d2) % 65536;
my $z=($TRXID2-$a*$TRXID1) % 65536;
print "a=$a z=$z\n";

print "Next TRXID is ".(((($a*$TRXID3) % 65536)+$z) % 65536)."\n";
exit(0);
