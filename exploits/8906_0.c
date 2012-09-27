static void
defang( char* str, char* dfstr, int dfsize )
    {
    char* cp1;
    char* cp2;

    for ( cp1 = str, cp2 = dfstr;
   *cp1 != '\0' && cp2 - dfstr < dfsize - 1;
   ++cp1, ++cp2 )
 {
 switch ( *cp1 )
     {
     case '<':
     *cp2++ = '&';
     *cp2++ = 'l';
     *cp2++ = 't';
     *cp2 = ';';
     break;
     case '>':
     *cp2++ = '&';
     *cp2++ = 'g';
     *cp2++ = 't';
     *cp2 = ';';
     break;
     default:
     *cp2 = *cp1;
     break;
     }
 }
    *cp2 = '\0';
    }

