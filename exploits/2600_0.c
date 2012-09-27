/*
 * repeat.c -- quick-n-dirty hack to output argv[2] instances of the
 * character whose ASCII value is given as argv[1]
 *
 * WARNING - this has absolutely no error checking!
 */

#include <stdio.h>

main (int argc, char **argv) {
  int character;
  long repetitions, i;

  if ( argc != 3 ) {
    printf("usage: repeat char reps\n");
    exit(1);
  }
  character = atoi(argv[1]);
  repetitions = atol(argv[2]);

  for (i = 0L; i < repetitions; i++) {
    printf ("%c", character);
  }
}
