struct sockaddr_in *sa, restoresa;
/* Set up two addresses with INADDR_ANY. */
sa = fork_malloc(sizeof(*sa));
sa->sin_len = sizeof(*sa);
sa->sin_family = AF_INET;
sa->sin_addr.s_addr = INADDR_ANY;
sa->sin_port = htons(8888);
restoresa = *sa;
/* Create child to overwrite *sa after 500k cycles. */
pid = fork_and_overwrite_smp_afterwait(sa, &restoresa,
sizeof(restoresa), 500000);
error = bind(sock, sa, sizeof(*sa));
