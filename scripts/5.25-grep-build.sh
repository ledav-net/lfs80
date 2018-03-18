#!/bin/sh

. ./2.00-environ.sh || exit 1

prerequis grep-3.0.tar.xz || exit 2

./configure --prefix=/tools

make || exit 2
[ $RUNCHECK == true ] && make check
make install
