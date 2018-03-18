#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis gdbm-1.12.tar.gz || exit 2

./configure --prefix=/usr \
            --disable-static \
            --enable-libgdbm-compat

make || exit 3
[ $RUNCHECK == true ] && make check
make install
