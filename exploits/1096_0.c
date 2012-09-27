#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>

int main(void)
{

while(1) {
	if(mkdir("aaaa",0777)<0) {
		perror("mkdir");
		exit(1);
		}
	if(chdir("aaaa")<0) {
		perror("chdir");
		exit(1);
		}
	}

return(0);
}
