#include <pthread.h>
#include <stdio.h>

int ok = 0;

void *func1(void *none)
{
	char buf[8];
	while(1)
	{
		if(!ok)
			continue;
		strcpy(buf, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		break;
	}
	puts("func1 overflow!");
}

void *func2(void *none)
{
	char buf[8];
	ok = 1;
	strcpy(buf, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
	puts("func2 overflow!!");
}

int main()
{
	pthread_t t1, t2;
	
	pthread_create(&t1, NULL, &func1, NULL);
	pthread_create(&t2, NULL, &func2, NULL);
	
	pthread_join(t1, NULL);
	pthread_join(t2, NULL);
	
	return 0;
}
