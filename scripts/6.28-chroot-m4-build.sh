#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis m4-1.4.18.tar.xz || exit 2

./configure --prefix=/usr

make || exit 3
[ $RUNCHECK == true ] && make check
make install
