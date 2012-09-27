/* To compile vuln.c :                              */
/* cc -o vuln vuln.c /path/to/opt-3.18/src/libopt.a */

main(int *argc, char **argv)
{
  /* use OPT opt_atoi() */
        int y = opt_atoi(argv[1]);        printf("opt_atoi(): %i\n", y);
}

