#!/bin/sh

. ./2.00-environ.sh || exit 1

prerequis bison-3.0.4.tar.xz || exit 2

./configure --prefix=/tools

make || exit 2
[ $RUNCHECK ==true ] && make check
make install
