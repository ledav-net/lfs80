#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis file-5.30.tar.gz || exit 2

./configure --prefix=/usr

make || exit 2
[ $RUNCHECK == true ] && make check
make install
