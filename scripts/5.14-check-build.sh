#!/bin/sh

. ./2.00-environ.sh || exit 1

prerequis check-0.11.0.tar.gz || exit 2

PKG_CONFIG= ./configure --prefix=/tools

make || exit 2
[ $RUNCHECK == true ] && make check
make install
