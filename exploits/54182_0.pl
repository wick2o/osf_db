POST / HTTP/1.0Content-Type: text/xmlContent-Length: 100Authorization:
Basic YWRtaW46
<?xml version="1.0" encoding="windows-1252"?><request>
<command>getoptions</command>
</request>

POST / HTTP/1.0Content-Type: text/xmlContent-Length: 100Authorization:
Basic *AAAA*
<?xml version="1.0" encoding="windows-1252"?><request>
<command>getoptions</command>
</request>

#!/usr/bin/env perl
 
use strict;
use warnings;
 
my $credentials = "AAAA";
 
#command: getrules 98
#command: getoptions 100
 
my $header = "POST / HTTP/1.0\r\n" .
    "Content-Type: text/xml\r\n" .
    "Content-Length: 100\r\n" .
    "Authorization: Basic $credentials\r\n" .
    "\r\n" .
    "<?xml version=\"1.0\" encoding=\"windows-1252\"?>\r\n" .
    "<request>\r\n" .
    "\t<command>getoptions</command>\r\n" .
    "</request>";
 
print $header;
