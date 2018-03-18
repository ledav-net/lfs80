#!/bin/sh

. ./2.00-environ.sh || exit 1

prerequis coreutils-8.26.tar.xz || exit 2

./configure --prefix=/tools --enable-install-program=hostname

make || exit 2
[ $RUNCHECK == true ] && make RUN_EXPENSIVE_TESTS=yes check
make install
