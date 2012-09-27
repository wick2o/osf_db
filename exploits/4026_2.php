<?php

function r($fp, &$buf, $len, &$err) {
      print fread($fp, $len);
}

$m = new mysqli('localhost', 'aaaa', '', 'a');
$m->options(MYSQLI_OPT_LOCAL_INFILE, 1);
$m->set_local_infile_handler("r");
$m->query("LOAD DATA LOCAL INFILE '/etc/passwd' INTO TABLE a.a");
$m->close();

?>