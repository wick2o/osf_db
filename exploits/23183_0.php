<?php
  ini_set("session.save_path", "/sessions/user2/");
  putenv("TMPDIR=/sessions/user2/");
  ini_set("session.save_path", "");
  @session_start();
?>
