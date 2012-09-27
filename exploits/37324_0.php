<?php
  $pwd_file = "http://localhost/smartphps/pwd.txt";
  $half_way = base64_decode(file_get_contents($pwd_file));
  $almost_there = explode("||&@23||password>||&~||", $half_way);
  echo base64_decode($almost_there[0])."\n";
?>