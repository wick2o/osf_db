/*
    * Copyright 2006-2011, Way to the Web Limited
    * URL: http://www.configserver.com
    * Email: sales@waytotheweb.com
*/
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <string.h>
#include <pwd.h>
main ()
{
    FILE *adminFile;
    uid_t ruid;
    char name[100];
    struct passwd *pw;
    int admin = 0;
 
    ruid = getuid();
    pw = getpwuid(ruid);
 
    adminFile=fopen ("/usr/local/directadmin/data/admin/admin.list","r");
    while(fgets(name,100,adminFile) != NULL)
    {
        int end = strlen(name) - 1;
        if (end >= 0 && name[end] == '\n') name[end] = '\0';
        //printf("Name [%s]\n", name);
        if (strcmp(pw->pw_name, name) == 0) admin = 1;
    }
    fclose(adminFile);
    if (admin == 1)
    {
        setuid(0);
        setgid(0);
        //setegid(0);
        //seteuid(0);
        execv("/usr/local/directadmin/plugins/csf/exec/da_csf.cgi", NULL);
    } else {
        printf("Permission denied [User:%s UID:%d]\n", pw->pw_name, ruid);
    }
    return 0;
}
