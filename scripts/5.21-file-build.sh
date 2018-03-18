#!/bin/sh

. ./2.00-environ.sh || exit 1

prerequis file-5.30.tar.gz || exit 2

./configure --prefix=/tools

make || exit 2
[ $RUNCHECK == true ] && make check
make install
