#!/bin/sh
. ./2.00-environ.sh || exit 1

prerequis make-4.2.1.tar.bz2 || exit 2

./configure --prefix=/tools --without-guile

make || exit 2
[ $RUNCHECK == true ] && make check
make install
