
#include <time.h>

int main(void)
{
	struct timespec ts;
	ts.tv_sec = 1;
	ts.tv_nsec = 0;

	return clock_nanosleep(4, 0, &ts, NULL);
}
