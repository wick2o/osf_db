$logfile='c:\windows\desktop\homebet.log'; ##change as required
print "Extracting Account/pin numbers";
open(INFILE,$logfile);
while(&lt;INFILE&gt;){
($accn,$pin)=split(/account=/,$_);
if ($pin){print "Account Number=".$pin;}
}
