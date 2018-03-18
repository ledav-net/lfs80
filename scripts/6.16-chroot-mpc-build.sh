#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis mpc-1.0.3.tar.gz || exit 2

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.0.3

make || exit 3
make html
[ $RUNCHECK == true ] && make check
make install
make install-html
