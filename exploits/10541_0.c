int main(int argc, char *argv[])
{
        int sockfd, pass=0, len;
        struct sockaddr_in server;

        if (argc < 4)
        {
                printf ("USAGE: %s IP port payload [paylen]\n", argv[0]);
                exit(1);
        }
        if (argc > 4)
                len = atoi(argv[4]);
        else
                len = strlen(argv[3]);

        server.sin_addr.s_addr = inet_addr(argv[1]);
        server.sin_port = htons(atoi(argv[2]));
        server.sin_family = AF_INET;

        while (1)
        {
                printf("pass: %d\n", ++pass);
                if ((sockfd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
                {
                        perror("socket");
                        exit(1);
                }

                if (connect(sockfd, (struct sockaddr *)&server, sizeof(struct sockaddr_in)) < 0)
                {
                        perror("connect");
                        continue;
                }

                if (send(sockfd, argv[3], len, 0) != len)
                {
                        perror("send");
                        exit(1);
                }

                close(sockfd);
        }
}

