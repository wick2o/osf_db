#!/bin/sh

if [ "$1" ]; then
	cat > /tmp/t.c <<EOF
#include <stdio.h>
int     main()
{
	int     i;
	while (fscanf(stdin, "%i", &i) > 0)
	{
		printf("%c%c", (i & 0xff00) >> 8, i & 0xff);
	}
	return 0;
}
EOF
	cat > /tmp/t.toc <<EOF
CD_ROM
TRACK MODE1_RAW
FILE "$1" 0
EOF
	gcc /tmp/t.c -o /tmp/show
	echo `cdrdao show-data -v 0 --force /tmp/t.toc 2>&1 | grep -v WARNING | sed 's/.*://g' ` | /tmp/show
	rm -f /tmp/t.c /tmp/show /tmp/t.toc
else
	echo "Syntax: $0 filename"
fi
