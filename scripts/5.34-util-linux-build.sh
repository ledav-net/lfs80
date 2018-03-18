#!/bin/sh
. ./2.00-environ.sh || exit 1

prerequis util-linux-2.29.1.tar.xz || exit 2

./configure --prefix=/tools                   \
            --without-python                  \
            --disable-makeinstall-chown       \
            --without-systemdsystemunitdir    \
            --enable-libmount-force-mountinfo \
            PKG_CONFIG=""

make || exit 2
make install
