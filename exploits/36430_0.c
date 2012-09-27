/* ... */
int main(int argc, char **argv)
{
  jmp_buf env;

  void handlesig(int n) {
        longjmp(env, 1);

  }
  signal(SIGSEGV, handlesig);

  if (setjmp(env) == 0) {
        ( (void(*)(void)) NULL) ();
  }

  return 0;
}

/* ... */
int main(int argc, char **argv)
{
       char baguette;
       signal(SIGABRT, (void (*)(int))&baguette);
       abort();
}
