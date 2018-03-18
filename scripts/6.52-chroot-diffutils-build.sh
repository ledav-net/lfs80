#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis diffutils-3.5.tar.xz || exit 2

sed -i.orig 's:= @mkdir_p@:= /bin/mkdir -p:' po/Makefile.in.in

./configure --prefix=/usr

make || exit 3
[ $RUNCHECK == true ] && make check
make install
