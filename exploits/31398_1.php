<?php
$funstring = 'return -1 * var_dump($a[""]);}phpinfo();/*"]';
$unused = create_function('',$funstring);
?>
