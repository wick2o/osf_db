/* id: gdbad2.c, Xavier Roche, May. 2006 */
/* gcc gdbad2.c -o bad -lgd && ./bad */

#include <stdio.h>
#include <stdlib.h>
#include "gd.h"

static const unsigned char gifdata[157];
int main(void) {
  gdImagePtr im;
  if ( ( im = gdImageCreateFromGifPtr(157, (char*) &gifdata[0]) ) != 
NULL) {
    fprintf(stderr, "success!\n");
    gdImageDestroy(im);
  } else {
    fprintf(stderr, "failed!\n");
  }
  return 0;
}

/* GIF data */
static const unsigned char gifdata[157] = {71,73,70,56,57,97,7,0,15,0,
227,0,0,221,221,221,205,205,205,188,188,188,171,171,171,155,155,155,138,
138,138,121,121,121,105,105,105,88,88,88,72,72,72,55,55,55,38,38,38,22,
22,22,5,5,5,0,0,0,255,255,255,33,254,21,67,114,101,97,116,101,100,32,
119,105,116,104,32,84,104,101,32,71,73,77,80,0,33,249,4,1,13,10,0,15,0,
44,0,0,0,0,7,0,15,0,0,4,48,16,128,71,105,184,161,138,189,233,248,224,67,
140,228,83,156,104,97,172,172,113,188,240,129,204,52,146,220,120,162,
236,252,179,252,192,7,99,56,164,52,142,141,138,195,81,161,68,0,0,59};
