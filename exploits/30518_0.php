&lt;?php

$sitekey=82397834;

$ts_random=$_REQUEST[&#039;ts_random&#039;];

$datekey = date(”F j”);

$rcode = hexdec(md5($_SERVER[&#039;HTTP_USER_AGENT&#039;] . $sitekey . $ts_random . $datekey));

print substr($rcode, 2, 6);

?&gt;