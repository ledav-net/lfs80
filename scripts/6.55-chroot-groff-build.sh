#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis groff-1.22.3.tar.gz || exit 2

PAGE=A4 ./configure --prefix=/usr

make -j1 || exit 3
make install
