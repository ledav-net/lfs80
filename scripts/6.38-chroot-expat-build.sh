#!/bin/sh

. ./2.00-environ.sh || exit 1

# autoswitch to chroot'ed environment if needed
[ -f /LFS_ROOT ] || chroot_exec $0

prerequis expat-2.2.0.tar.bz2 || exit 2

./configure --prefix=/usr --disable-static

make || exit 3
[ $RUNCHECK == true ] && make check
make install

install -v -dm755 /usr/share/doc/expat-2.2.0
install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.2.0
