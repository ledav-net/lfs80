#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis bison-3.0.4.tar.xz || exit 2

./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.0.4

make || exit 3
make install

