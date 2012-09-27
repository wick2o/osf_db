<?php

ini_set("session.save_path", "0123456789ABCDEF");
ini_restore("session.save_path");
session_start();
?>
