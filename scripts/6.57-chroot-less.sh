#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis less-481.tar.gz || exit 2

./configure --prefix=/usr --sysconfdir=/etc

make || exit 3
make install
