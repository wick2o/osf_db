#include <stdio.h>
#include <windows.h>

int main( void )
{
        HWND hWnd;
        char szWindowName[] = "Altiris Client Service";

        printf( "Finding window %s\n", szWindowName );

        hWnd = FindWindow( NULL, szWindowName );

        if ( hWnd == NULL )
        {
                printf( "ERROR! Could not find window %s\n", szWindowName );

                exit( 1 );
        }

        ShowWindow( hWnd, SW_SHOW );

        return 0;
}
