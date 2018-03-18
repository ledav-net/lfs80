#!/bin/sh

. ./2.00-environ.sh || exit 1

prerequis expect5.45.tar.gz || exit 2

sed 's|/usr/local/bin|/bin|' -i.orig configure

./configure --prefix=/tools       \
            --with-tcl=/tools/lib \
            --with-tclinclude=/tools/include

make || exit 2
[ $RUNCHECK == true ] && make test
make SCRIPTS="" install
