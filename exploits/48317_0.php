<?php
//trackback.php - Line 33 - 35
$url=urldecode($_REQUEST['url']);
if (validate_url($url)==false) { $tback->trackback_reply(1, "<p>Sorry, Trackback failed.. Reason : URL not valid</p>"); }

?>


<?php
//trackback.php - Line 750
function validate_url($url) {
    if  ( ! preg_match('#^http\\:\\/\\/[a-z0-9\-]+\.([a-z0-9\-]+\.)?[a-z]+#i', $url, $matches) ) {
       return false;
    } else {
       return true;  
    }
} 
?>

