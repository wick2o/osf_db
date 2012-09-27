    pipe(pfds);
    snprintf(buf, sizeof(buf), "/tmp/%d", getpid());
    fd = open(buf, O_RDWR | O_CREAT, S_IRWXU);

    if (fork()) {
        splice(pfds[0], NULL, fd, NULL, 1024, NULL);
    } else{
        sleep(1);
        splice(pfds[0], NULL, fd, NULL, 1024, NULL);
    }
