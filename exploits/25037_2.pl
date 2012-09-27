# For BIND9 v9.2.3-9.4.1:
$tap1=0x80000057;
$tap2=0x80000062;

# For BIND9 v9.0.0-9.2.2:
# $tap1=0xc000002b; # (0x80000057>>1)|(1<<31)
# $tap2=0xc0000061; # (0x800000c2>>1)|(1<<31)

$txid=hex($ARGV[0]);

if (($txid & 1)!=0)
{
	die "lsb is not 0. Can't predict the next transaction ID.\n";
}

# One bit shift (assuming the two lsb's are 0 and 0)
for ($msb=0;$msb<(1<<1);$msb++)
{
	push @cand,(($msb<<15)|($txid>>1)) & 0xFFFF;
}

# Two bit shift (assuming the two lsb's are 1 and 1)
# First shift (we know the lsb is 1 in both LFSRs):
$v=$txid;
$v=($v>>1)^$tap1^$tap2;
if (($v & 1)==0)
{
# After the first shift, the lsb becomes 0, so the two LFSRs now have 
#	identical lsb's: 0 and 0   or   1 and 1
	# Second shift:
	$v1=($v>>1); # 0 and 0
	$v2=($v>>1)^$tap1^$tap2; # 1 and 1
}
else
{
	# After the first shift, the lsb becomes 1, so the two LFSRs now have 
#	different lsb's: 1 and 0   or   0 and 1
	# Second shift:
	$v1=($v>>1)^$tap1; # 1 and 0
	$v2=($v>>1)^$tap2; # 0 and 1
}

# Also need to enumerate over the 2 msb's we are clueless about
for ($msbits=0;$msbits<(1<<2);$msbits++)
{
	push @cand,(($msbits<<14)|$v1) & 0xFFFF;
	push @cand,(($msbits<<14)|$v2) & 0xFFFF;
}

print"Predicting - the next transaction ID is one of: ";
for (my $k=0;$k<10;$k++)
{
	printf "%04x ",$cand[$k];
}

exit(0);
