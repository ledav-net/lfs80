#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis tar-1.29.tar.xz || exit 2

FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr \
            --bindir=/bin

make || exit 3
[ $RUNCHECK == true ] && make check
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.29
