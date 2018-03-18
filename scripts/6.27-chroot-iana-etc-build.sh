#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis iana-etc-2.30.tar.bz2 || exit 2

make || exit 3
make install
