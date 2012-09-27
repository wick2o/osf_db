#include <windows.h>
int main()
{
 WCHAR c[1000] = {0};
 memset(c, ‘c’, 1000);
 SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, (PVOID)c, 0);

 WCHAR b[1000] = {0};
 SystemParametersInfo(SPI_GETDESKWALLPAPER, 1000, (PVOID)b, 0);
 return 0;
}