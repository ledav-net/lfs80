#!/bin/sh

. ./2.00-environ.sh || exit 1

prerequis dejagnu-1.6.tar.gz || exit 2

./configure --prefix=/tools

[ $RUNCHECK == true ] && make check
make install
