#!/bin/sh

. ./2.00-environ.sh || exit 1

prerequis ncurses-6.0.tar.gz || exit 2

sed -i.orig s/mawk// configure

./configure --prefix=/tools \
            --with-shared    \
            --without-debug  \
            --without-ada    \
            --enable-widec   \
            --enable-overwrite

make && make install
