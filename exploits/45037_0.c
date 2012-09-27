#include <sys/mount.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <sys/wait.h>

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static int send_fd(int unix_fd, int fd)
{
        struct msghdr msgh;
        struct cmsghdr *cmsg;
        char buf[CMSG_SPACE(sizeof(fd))];

        memset(&msgh, 0, sizeof(msgh));

        memset(buf, 0, sizeof(buf));
        msgh.msg_control = buf;
        msgh.msg_controllen = sizeof(buf);

        cmsg = CMSG_FIRSTHDR(&msgh);
        cmsg->cmsg_len = CMSG_LEN(sizeof(fd));
        cmsg->cmsg_level = SOL_SOCKET;
        cmsg->cmsg_type = SCM_RIGHTS;

        msgh.msg_controllen = cmsg->cmsg_len;

        memcpy(CMSG_DATA(cmsg), &fd, sizeof(fd));
        return sendmsg(unix_fd, &msgh, 0);
}

int main(int argc, char *argv[])
{
        while (1) {
                pid_t child;

                child = fork();
                if (child == -1)
                        exit(EXIT_FAILURE);

                if (child == 0) {
                        int fd[2];
                        int i;

                        if (socketpair(PF_UNIX, SOCK_SEQPACKET, 0, fd) == -1)
                                goto out_error;

                        for (i = 0; i < 100; ++i) {
                                if (send_fd(fd[0], fd[0]) == -1)
                                        goto out_error;

                                if (send_fd(fd[1], fd[1]) == -1)
                                        goto out_error;
                        }

                        close(fd[0]);
                        close(fd[1]);
                        goto out;

                out_error:
                        fprintf(stderr, "error: %s\n", strerror(errno));
                out:
                        exit(EXIT_SUCCESS);
                }

                while (1) {
                        pid_t kid;
                        int status;

                        kid = wait(&status);
                        if (kid == -1) {
                                if (errno == ECHILD)
                                        break;
                                if (errno == EINTR)
                                        continue;

                                exit(EXIT_FAILURE);
                        }

                        if (WIFEXITED(status)) {
                                if (WEXITSTATUS(status))
                                        exit(WEXITSTATUS(status));
                                break;
                        }
                }
        }

        return EXIT_SUCCESS;
}