#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <sys/socket.h>

typedef struct {
        char type[28];
        char name[32];
        char user[16];
        char pass[16];
}
__attribute__ ((packed)) answer;

int main()
{
        char rcvbuffer[1024];
        struct sockaddr_in sin;
        answer* ans = (answer *)rcvbuffer;
        int sd, ret, val;

        sin.sin_family          = AF_INET;
        sin.sin_addr.s_addr     = inet_addr("255.255.255.255");
        sin.sin_port            = htons(27155);

        sd = socket(AF_INET, SOCK_DGRAM, 0);
        if (sd < 0)
                perror("socket");

        val = 1;
        ret = setsockopt(sd, SOL_SOCKET, SO_BROADCAST, &val, sizeof(val));
        if (ret < 0)
        {
                perror("setsockopt");
                exit(1);
        }

        ret = sendto(sd, "gstsearch", 9, 0, &sin, sizeof(struct sockaddr));
        if (ret < 0)
        {
                perror("sendto");
                exit(1);
        }

        ret = read(sd,&rcvbuffer,sizeof(rcvbuffer));

        printf("Type            : %s\n",ans->type);
        printf("Announced Name  : %s\n",ans->name);
        printf("Admin Username  : %s\n",ans->user);
        printf("Admin Password  : %s\n",ans->pass);

        return 0;
}
